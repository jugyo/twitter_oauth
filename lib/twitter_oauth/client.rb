require 'twitter_oauth/timeline'
require 'twitter_oauth/status'
require 'twitter_oauth/account'
require 'twitter_oauth/direct_messages'
require 'twitter_oauth/search'
require 'twitter_oauth/notifications'
require 'twitter_oauth/blocks'
require 'twitter_oauth/friendships'
require 'twitter_oauth/user'
require 'twitter_oauth/favorites'
require 'twitter_oauth/utils'
require 'twitter_oauth/trends'
require 'twitter_oauth/lists'
require 'twitter_oauth/saved_searches'
require 'twitter_oauth/spam'
require 'twitter_oauth/geo'
require 'twitter_oauth/version'

module TwitterOAuth
  class Client

    def initialize(options = {})
      @consumer_key = options[:consumer_key]
      @consumer_secret = options[:consumer_secret]
      @token = options[:token]
      @secret = options[:secret]
      @proxy = options[:proxy]
      @debug = options[:debug]
      @secure = options[:secure]
      @api_version = options[:api_version] || '1'
      @api_host = options[:api_host] || 'api.twitter.com'
      @search_host = options[:search_host] || 'search.twitter.com'
    end

    def authorize(token, secret, options = {})
      request_token = OAuth::RequestToken.new(
        consumer(:secure => true), token, secret
      )
      @access_token = request_token.get_access_token(options)
      @token = @access_token.token
      @secret = @access_token.secret
      @access_token
    end

    def show(username)
      get("/users/show/#{username}.json")
    end

    # Returns the string "ok" in the requested format with a 200 OK HTTP status code.
    def test
      get("/help/test.json")
    end

    def request_token(options={})
      consumer(:secure => true).get_request_token(options)
    end

    def authentication_request_token(options={})
      consumer(:secure => true).options[:authorize_path] = '/oauth/authenticate'
      request_token(options)
    end

    private

      def consumer(options={})
        options[:secure] ||= @secure
        protocol = options[:secure] ? 'https' : 'http'
        @consumer ||= OAuth::Consumer.new(
          @consumer_key,
          @consumer_secret,
          { :site => "#{protocol}://#{@api_host}", :request_endpoint => @proxy }
        )
      end

      def access_token
        @access_token ||= OAuth::AccessToken.new(consumer, @token, @secret)
      end

      # Prefix path with the API version and remove double-slashes
      #
      # Double-slashes can occur when the API version is the empty
      # string, e.g. identi.ca.  Removing them is necessary because
      # URI.parse explodes when input starts with double-slash and
      # contains underscore, e.g. '//direct_messages.json?count=1'
      #
      def api_path(path)
        "/#{@api_version}#{path}".sub(/\/+/, "/")
      end

      def get(path, headers={})
        headers.merge!("User-Agent" => "twitter_oauth gem v#{TwitterOAuth::VERSION}")
        oauth_response = access_token.get(api_path(path), headers)
        parse(oauth_response.body)
      end

      def post(path, body='', headers={})
        headers.merge!("User-Agent" => "twitter_oauth gem v#{TwitterOAuth::VERSION}")
        oauth_response = access_token.post(api_path(path), body, headers)
        parse(oauth_response.body)
      end

      def delete(path, headers={})
        headers.merge!("User-Agent" => "twitter_oauth gem v#{TwitterOAuth::VERSION}")
        oauth_response = access_token.delete(api_path(path), headers)
        parse(oauth_response.body)
      end

      def parse(response_body)
        begin
          JSON.parse(response_body)
        rescue JSON::ParserError
          {:response => response_body}.to_json
        end
      end
  end
end

