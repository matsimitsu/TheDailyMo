module DailyMo
  module NetworkConnectors
    @available_connectors = {}

    def self.register_connector(network_name)
      @available_connectors[network_name] = "::DailyMo::NetworkConnectors::#{network_name.classify}Connector".constantize
      @network_list = nil
      true
    end

    def self.registered_connector?(network_name)
      @available_connectors.key?(network_name)
    end

    def self.connector(network_name)
      @available_connectors[network_name]
    end

    def self.connectors
      @available_connectors.dup
    end

    def self.networks
      @network_list ||= @available_connectors.keys
    end

  end
end

require 'network_connectors/facebook_connector'
require 'network_connectors/twitter_connector'
