require "open-uri"
module WebsocketNotifierPatch
  CONFIG_PATH = File.dirname(__FILE__) + '/../config/websocket.yml'
  DEFAULT_WEBSOCKET_CONFIG = {'websocket' => {'host' => '127.0.0.1', 'redmine_side_port' => 4567, 'client_side_port' => 18082, 'use_ssl' => false}}
  config = nil
  if File.exists?(CONFIG_PATH)
    open(CONFIG_PATH) {|f| config = YAML::load(f.read)}
  end
  LOADED_WEBSOCKET_CONFIG = config

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      after_create :send_message    
      cattr_accessor :websocket_config
      @@websocket_config = LOADED_WEBSOCKET_CONFIG || DEFAULT_WEBSOCKET_CONFIG
      @@websocket_config['websocket'] = DEFAULT_WEBSOCKET_CONFIG['websocket'].merge(@@websocket_config['websocket'])
    end
  end
  module InstanceMethods
    def send_message
      protocol = self.class.websocket_config['websocket']['use_ssl'] ? 'https' : 'http'
      host = self.class.websocket_config['websocket']['host'] || '127.0.0.1'
      port = self.class.websocket_config['websocket']['redmine_side_port'] || '4567'
      message = "#{event_title}\n#{event_description}"
      url = "#{protocol}://#{host}:#{port}/?message=#{URI.escape(message)}"
      begin
        open(url)
      rescue
        # ignore connection error
        logger.warn "cannot open websocket server: #{url}"
      end
    end
  end
end
