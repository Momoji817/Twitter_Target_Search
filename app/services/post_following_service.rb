require 'json'
require 'uri'
require 'net/http'
require 'securerandom'
require 'base64'
require 'openssl'
require 'erb'

class PostFollowingService
  TWITTER_API_DOMAIN = "https://api.twitter.com/2"
  TWITTER_CONSUMER_SECRET = Rails.application.credentials.twitter[:secret_key]

  def initialize(current_user, target_user_id)
    @user = current_user
    @target_user_id = target_user_id
  end

  def post_following
    uri = URI.parse(TWITTER_API_DOMAIN + "/users/#{@user.authentication.uid}/following")
    request_body_hash = { target_user_id: @target_user_id }
    
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = JSON.generate(request_body_hash)
    request["Authorization"] = authorization_value

    options = { use_ssl: true }

    response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
      http.request(request)
    end
    
    JSON.parse(response.body)
  end
  
  private
  
  def authorization_value
    authorization_params = create_params.merge(
      oauth_signature: generate_signature("POST", TWITTER_API_DOMAIN + "/users/#{@user.authentication.uid}/following")
    )
    return "OAuth " + authorization_params.sort.to_h.map{|k, v| "#{k}=\"#{v}\"" }.join(",")
  end

  # oauth_signature以外のパラメーターを生成
  def create_params
    @create_params ||= {
      oauth_consumer_key: Rails.application.credentials.twitter[:key],
      oauth_nonce: SecureRandom.alphanumeric,
      oauth_signature_method: "HMAC-SHA1",
      oauth_timestamp: Time.zone.now.to_i,
      oauth_token: @user.authentication.access_token,
      oauth_version: "1.0"
    }
  end

  # oauth_signature以外の認証用情報を生成
  def oauth_values
    values = create_params.sort.to_h.map {|k, v| "#{k}=#{v}" }.join("&")
    ERB::Util.url_encode(values)
  end

  # oauth_signatureを生成
  def generate_signature(method, url)
    signature_data = [method, ERB::Util.url_encode(url), oauth_values].join("&")
    signature_key = "#{ERB::Util.url_encode(TWITTER_CONSUMER_SECRET)}&#{ERB::Util.url_encode(@user.authentication.access_token_secret)}"
    signature_binary = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, signature_key, signature_data)
    return ERB::Util.url_encode(Base64.strict_encode64(signature_binary))
  end
end
