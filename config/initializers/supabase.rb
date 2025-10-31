require "faraday"
require "jwt"
require "json"
require_relative "supabase_constants"
require_relative "supabase_jwks"

include SupabaseConstants

module SupabaseAuth
  # Classes and methods to handle errors    
  class AuthenticationError < StandardError; end
  class ServiceError < StandardError
    attr_reader :status, :body
    def initialize(message, status:, body:); super(message); @status = status; @body = body; end
  end

  module_function

  def http
    # This http client parses json response itself
    @http ||= Faraday.new(url: SUPABASE_URL) do |faraday|
      faraday.request  :json
      faraday.response :json, content_type: /\bjson$/ 
      faraday.adapter  Faraday.default_adapter
    end
  end

  # self parsed JSON response is returned from log_in
  def log_in(email:, password:)
    response = http.post("/auth/v1/token") do |req|
      req.params["grant_type"]    = "password"
      req.headers["apikey"]       = SUPABASE_API_KEY
      req.headers["Authorization"]= "Bearer #{SUPABASE_API_KEY}"
      req.headers["Content-Type"] = "application/json"
      req.headers["Accept"]       = "application/json"
      req.body = { email: email, password: password }
    end

    case response.status
    # if HTTP = 200, login successful
    when 200
      return response.body # already a Hash
    # HTTP = 400, login failed
    when 400, 401
        # Bad credentials
      Rails.logger.debug("Supabase 400/401: #{resp.body.inspect}")
      msg = extract_msg(resp.body) || "Invalid login"
      raise AuthenticationError, msg
    else
        # Connectivity or other unexpected errors
      Rails.logger.warn("Supabase unexpected #{resp.status}: #{resp.body.inspect}")
      raise ServiceError.new("Auth service error", status: resp.status, body: resp.body)
    end
  rescue Faraday::Error => e
    st  = e.respond_to?(:response) ? e.response&.dig(:status) : nil
    bod = e.respond_to?(:response) ? e.response&.dig(:body)   : nil
    raise ServiceError.new("Network/HTTP error: #{e.message}", status: st || 0, body: bod)
  end

  def extract_msg(body)
    h = body.is_a?(Hash) ? body : JSON.parse(body) rescue {}
    h["error_description"] || h["msg"] || h["error"]
  end

  # Refresh a user's session using refresh token
    def refresh_session(refresh_token:)
        raise ArgumentError, "Refresh token is blank" if refresh_token.to_s.strip.empty?

        begin
            http.post("#{SUPABASE_URL}/auth/v1/token?grant_type=refresh_token") do |req|
                req.headers["apikey"] = SUPABASE_API_KEY
                req.headers["Content-Type"] = "application/json"
                req.body = { refresh_token: refresh_token }.to_json
            end
        rescue Faraday::Error => e
            raise AuthenticationError, "Session refresh failed: #{e.message}"
        rescue JSON::ParserError => e
            raise AuthenticationError, "Invalid response format: #{e.message}"
        end
    end

    # Sign up new user
    def sign_up(email:, password:)
        raise ArgumentError, "Email cannot be blank" if email.to_s.strip.empty?
        raise ArgumentError, "Password cannot be blank" if password.to_s.strip.empty?

        begin
            http.post("#{SUPABASE_URL}/auth/v1/signup") do |req|
                req.headers["apikey"] = SUPABASE_API_KEY
                req.headers["Content-Type"] = "application/json"
                req.body = { email: email, password: password }.to_json
            end
        rescue Faraday::Error => e
            raise AuthenticationError, "Sign up failed: #{e.message}"
        rescue JSON::ParserError => e
            raise AuthenticationError, "Invalid response format: #{e.message}"
        end
    end

    # Key lookup using supabase_jwks.rb methods
    def public_key_for(kid)
        key = Object.method(:find_key).call(kid)
        raise AuthenticationError, "Public key not found for kid: #{kid}" unless key
        key
    end

    # Verify JWT token using Supabase JWKS
    def verify_jwt(token)
        header = JWT.decode(token, nil, false).last
        public_key = public_key_for(header["kid"])
        decoded = JWT.decode(token, public_key, true, { algorithm: 'RS256' })
        decoded
  rescue JWT::DecodeError => e
    raise AuthenticationError, "JWT verification failed: #{e.message}"
  rescue JWT::ExpiredSignature
    raise AuthenticationError, "Token has expired #{e.message}"
  rescue JWT::InvalidIssuerError
    raise AuthenticationError, "Invalid token issuer #{e.message}"
    end
end