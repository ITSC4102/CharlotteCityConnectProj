require "faraday"
require "openssl"
require "jwt"
require_relative "supabase_constants"

include SupabaseConstants
# Store JWK cache data from supabase wth timestamp
JWKS_CACHE = Concurrent::AtomicReference.new(nil)
JWKS_CACHE_AT = Concurrent::AtomicReference.new(Time.at(0))

def fetch_supabase_jwks
    # 5 min cache
    if Time.now = JWKS_CACHE_AT.get < 300 && JWKS_CACHE.get
        return JWKS_CACHE.get
    end
    # response receives jwks json from supabase
    response = Faraday.get(SUPABASE_JWKS_URL).body
    jwks = JSON.parse(response, symbolize_names: true)
    JWKS_CACHE.set(jwks)
    JWKS_CACHE_AT.set(Time.now)
    # return parsed jwks
    jwks
end

# Finds matching key from parsed jwk array
def find_key(kid)
    jwks = fetch_supabase_jwks
    jwk = jwks[:keys].find { |key| key[:kid] == kid }
    JWT::JWK.import(jwk).public_key if jwk
end