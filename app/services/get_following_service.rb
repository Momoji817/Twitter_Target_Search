require 'json'
require 'uri'
require 'net/http'
require 'securerandom'
require 'base64'
require 'openssl'
require 'erb'

class GetFollowingService
  TWITTER_API_DOMAIN = 'https://api.twitter.com/2'
  TWITTER_CONSUMER_SECRET = Rails.application.credentials.twitter[:secret_key]

  def initialize(current_user)
    @user = current_user
    @next_token = nil
  end

  def create_optional_params
    @create_optional_params ||= {
      max_results: 1000
    }
    if @next_token.blank?
      @create_optional_params
    else
      next_token = { pagination_token: @next_token }
      @create_optional_params.merge!(next_token)
    end
  end

  def request
    uri = URI.parse(TWITTER_API_DOMAIN + "/users/#{@user.authentication.uid}/following")
    uri.query = URI.encode_www_form(create_optional_params)

    request = Net::HTTP::Get.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = authorization_value

    options = { use_ssl: true }

    response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def get_following
    @following = request.flatten.flatten
    @following_next_token = @following.last

    if @following_next_token == 429
      return 'error'
    end

    while @following_next_token['next_token'].present?
      @next_token = @following_next_token['next_token']
      next_request = request
      @following.pop
      @following += next_request.flatten
      @following_next_token = @following.last

      if @following_next_token == 429
        return 'error'
      end
    end
    @following.flatten.map { |x| x['id'] }.compact
  end

  private

  def authorization_value
    authorization_params = create_params.merge(
      oauth_signature: generate_signature('GET', TWITTER_API_DOMAIN + "/users/#{@user.authentication.uid}/following")
    )
    'OAuth ' + authorization_params.sort.to_h.map { |k, v| "#{k}=\"#{v}\"" }.join(',')
  end

  # oauth_signature以外のパラメーターを生成
  def create_params
    @create_params ||= {
      oauth_consumer_key: Rails.application.credentials.twitter[:key],
      oauth_nonce: SecureRandom.alphanumeric,
      oauth_signature_method: 'HMAC-SHA1',
      oauth_timestamp: Time.zone.now.to_i,
      oauth_token: @user.authentication.access_token,
      oauth_version: '1.0'
    }
  end

  # oauth_signature以外の認証用情報を生成
  def oauth_values
    values = create_params.merge(create_optional_params).sort.to_h.map { |k, v| "#{k}=#{v}" }.join('&')
    ERB::Util.url_encode(values)
  end

  # oauth_signatureを生成
  def generate_signature(method, url)
    signature_data = [method, ERB::Util.url_encode(url), oauth_values].join('&')
    signature_key = "#{ERB::Util.url_encode(TWITTER_CONSUMER_SECRET)}&#{ERB::Util.url_encode(@user.authentication.access_token_secret)}"
    signature_binary = OpenSSL::HMAC.digest(OpenSSL::Digest.new('SHA1'), signature_key, signature_data)
    ERB::Util.url_encode(Base64.strict_encode64(signature_binary))
  end
end
