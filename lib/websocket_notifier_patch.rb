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
      open("http://localhost:4567/message?activity=#{URI.escape(message)}")
    end
  end
end
