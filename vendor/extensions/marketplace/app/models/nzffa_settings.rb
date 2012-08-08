class NzffaSettings

  def self.set(key, value)
    @nzffa_settings ||= {}
    @nzffa_settings[key] = value
  end

  def self.get(key)
    @nzffa_settings[key]
  end
end
