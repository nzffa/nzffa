class XeroAuth
  class_attribute :token

  class << self
    def authorize_url
      client.authorize_url(redirect_uri: XERO_CALLBACK_URL, scope:"accounting.transactions accounting.contacts offline_access")
    end

    def client
      get_token_from_ymlconf if self.token.nil?
      @client ||= Xeroizer::OAuth2Application.new(
        XERO_CONSUMER_KEY,
        XERO_CONSUMER_SECRET,
	      access_token: self.token[:access_token],
        refresh_token: self.token[:refresh_token],
        tenant_id: ymlconf['xero']['tenant_id']
      )
    end

    def reconnect_from_refresh_token
      client.renew_access_token
      self.write_tokens
    end

    def get_token_from_auth_code(code)
      self.token = client.authorize_from_code(code, redirect_uri: XERO_CALLBACK_URL).to_hash
      self.write_tokens if self.still_active?
    end

    def get_token_from_ymlconf
      self.token = {}
      self.token[:access_token] = ymlconf['xero']['access_token']
      self.token[:refresh_token] = ymlconf['xero']['refresh_token']
    end

    def still_active?
      !self.client.client.access_token.nil? &&
      !self.client.client.access_token.expires_at.nil? &&
      self.client.client.access_token.expires_at > Time.now.to_i
    end

    def write_tokens
      ymlconf['xero']['access_token'] = self.token[:access_token]
      ymlconf['xero']['refresh_token'] = self.token[:refresh_token]
      File.open("#{Rails.root}/config/application.yml", "w"){|f| f.write(ymlconf.to_yaml)}
    end

    def ymlconf
      @ymlconf ||= YAML.load_file("#{Rails.root}/config/application.yml")
    end

  end

end
