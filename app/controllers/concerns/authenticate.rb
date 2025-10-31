module Authenticate
    # reads incoming HTTP request for Authorization header
    def authenticate_request
        header = request.headers["Authorization"]
        token = header&.split&.last
        # return error message unless token exists
        return render json: { error: "Missing token" }, status: :unauthorized unless token

        begin
            # collects kid from token header
            header_kid = JWT.decode(token, nil, false).last["kid"]
           
            # finds matching key from function in app/config/initializers/supabase_jwks.rb
            public_key = find_key(header_kid)
            raise JWT::DecodeError, "No matching key found" unless public_key
            
            # verifies token with public key and RS256 algorithm
            decoded_key = JWT.decode(token, public_key, true, { algorithm: "RS256" })
            @current_user_claims = decoded_key.with_indifferent_access
        rescue JWT::DecodeError => e
            return render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized            
        end
    end

    # reutrns current user id from token claims
    def current_user_id
        return nil unless @current_user_claims

        sub = @current_user_claims&.[](:sub)
        raise JWT::InvalidSubError, "Missing subject claim, current_user_id failed" unless sub

        sub
    end
end