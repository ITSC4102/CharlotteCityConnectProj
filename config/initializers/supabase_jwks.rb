require "faraday"
require "openssl"
require "jwt"
require "time"
require "tzinfo"
require_relative "supabase_constants"

include SupabaseConstants
# Store JWK cache data from supabase wth timestamp
JWKS_CACHE = Concurrent::AtomicReference.new(nil)
JWKS_CACHE_AT = Concurrent::AtomicReference.new(Time.at(0))

def fetch_supabase_jwks
  now = Time.now
  cached_at = JWKS_CACHE_AT.get
  cached    = JWKS_CACHE.get

  if cached && (now - cached_at < JWKS_TTL)
    return cached
  end

  Rails.logger.info "=== JWKS FETCH START ==="
  Rails.logger.info "JWKS URL: #{SUPABASE_JWKS_URL}"
  Rails.logger.info "API KEY PREFIX: #{SUPABASE_API_KEY[0..6]}..."

  response = Faraday.get(SUPABASE_JWKS_URL) do |req|
    req.headers["apikey"]        = SUPABASE_API_KEY
    req.headers["Authorization"] = "Bearer #{SUPABASE_API_KEY}"
    req.headers["Accept"]        = "application/json"
  end

  Rails.logger.info "JWKS STATUS: #{response.status}"
  Rails.logger.info "JWKS HEADERS SENT: #{response.env.request_headers.inspect}"
  Rails.logger.info "JWKS BODY: #{response.body}"

  unless response.status == 200
    raise "Failed to load JWKS: #{response.body}"
  end

  jwks = JSON.parse(response.body, symbolize_names: true)
  JWKS_CACHE.set(jwks)
  JWKS_CACHE_AT.set(now)
  jwks
end




# Finds matching key from parsed jwk array
def find_key(kid)
    jwks = fetch_supabase_jwks
    Rails.logger.error("JWKS DATA: #{jwks.inspect}")

    jwk = jwks[:keys].find { |key| key[:kid] == kid }
    JWT::JWK.import(jwk).public_key if jwk
end