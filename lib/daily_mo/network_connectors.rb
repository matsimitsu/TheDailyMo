module DailyMo
  module NetworkConnectors
    @available_connectors = {}

    def self.register_connector(network_name)
      @available_connectors[network_name] = "::DailyMo::NetworkConnectors::#{network_name.classify}Connector".constantize
      @network_list = nil
      connector(network_name)
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

require 'daily_mo/network_connectors/facebook_connector'
require 'daily_mo/network_connectors/twitter_connector'
