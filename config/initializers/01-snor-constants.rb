module TheDailyMo
  module AuthKeys

    def self.network_keys_and_secret(network_name)
      key, secret = ENV["#{network_name}_key"], ENV["#{network_name}_secret"]
      return [key, secret] if key.present? and secret.present?

      auth_keys = self.load_keys

      if auth_hash = auth_keys[network_name]
        [auth_hash[:key], auth_hash[:secret]]
      else
        raise "No such key! (#{network_name})"
      end
    end

    def self.bucket(network_name)
      bucket = ENV["#{network_name}_bucket"]
      return bucket if bucket.present?

      auth_keys = self.load_keys

      if auth_hash = auth_keys[network_name]
        auth_hash[:bucket]
      else
        raise "No such key! (#{network_name})"
      end
    end

  private

    def self.load_keys
      @auth_keys ||= begin
        raw_config = File.read(Dir[Rails.root.join('config', "network_keys.yml")].to_s)
        YAML.load(raw_config).symbolize_keys
      end
    end

  end
end