module DailyMo

  def self.network_key_and_secret(network_name)
    DailyMo::NetworkConnectors.available_connectors(network_name)
  end

end

require 'daily_mo/network_connectors'
