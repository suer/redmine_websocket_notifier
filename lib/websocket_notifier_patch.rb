require "open-uri"
module WebsocketNotifierPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      after_create :send_message    
      puts self.class
      cattr_accessor :websocket_server
    end
  end
  module InstanceMethods
    def send_message
      message = "#{event_title}\n#{event_description}"
      self.class.websocket_server.send_message(message, logger)
    end
  end
end
