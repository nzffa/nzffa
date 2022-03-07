class XeroConnection
  class_attribute :token

  class << self
    def authorize_url
      client.authorize_url(redirect_uri: XERO_CALLBACK_URL, scope:"accounting.transactions accounting.contacts offline_access")
    end

    def client
      get_tokens_from_ymlconf if self.token.nil?
      @@client ||= Xeroizer::OAuth2Application.new(
        XERO_CONSUMER_KEY,
        XERO_CONSUMER_SECRET,
	      access_token: self.token[:access_token],
        refresh_token: self.token[:refresh_token],
        tenant_id: ymlconf['xero']['tenant_id']
      )
    end

    def get_tokens_from_auth_code(code)
      self.token = client.authorize_from_code(code, redirect_uri: XERO_CALLBACK_URL).to_hash
      self.write_tokens if self.still_active?
    end

    def get_tokens_from_ymlconf
      self.token = {}
      self.token[:access_token] = ymlconf['xero']['access_token']
      self.token[:refresh_token] = ymlconf['xero']['refresh_token']
    end

    def reconnect_from_refresh_token
      if self.token && self.token[:refresh_token]
        begin
          client.renew_access_token
          self.write_tokens
        rescue NoMethodError
          # Sometimes fails causing ApplicationError, but I don't understand why
          # Fail silently to avoid ApplicationError and let user re-authorize
# 3: from /home/jomz/Development/nzffa/vendor/extensions/nzffa/lib/xero_connection.rb:33:in `reconnect_from_refresh_token'
# 2: from /usr/lib/ruby/2.7.0/forwardable.rb:235:in `renew_access_token'
# 1: from /home/jomz/Development/nzffa/vendor/bundle/ruby/2.7.0/bundler/gems/xeroizer-93417c66b0d4/lib/xeroizer/oauth2.rb:29:in `renew_access_token'
# /home/jomz/Development/nzffa/vendor/bundle/ruby/2.7.0/gems/oauth2-1.4.7/lib/oauth2/access_token.rb:89:in `refresh!': undefined method `options=' for nil:NilClass (NoMethodError)
        end
      end
    end

    def still_active?
      !self.client.client.access_token.nil? &&
      !self.client.client.access_token.expires_at.nil? &&
      self.client.client.access_token.expires_at > Time.now.to_i
    end

    def verify
      reconnect_from_refresh_token unless still_active?
      still_active?
    end

    def write_tokens
      ymlconf['xero']['access_token'] = self.token[:access_token]
      ymlconf['xero']['refresh_token'] = self.token[:refresh_token]
      File.open("#{Rails.root}/config/application.yml", "w"){|f| f.write(ymlconf.to_yaml)}
    end

    def ymlconf
      @@ymlconf ||= YAML.load_file("#{Rails.root}/config/application.yml")
    end

  end

end
