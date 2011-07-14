require "open-uri"
module WebsocketNotifierPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      after_create :send_to_websocket    
    end
  end
  module InstanceMethods
    def send_to_websocket
      message = "#{event_title}\n#{event_title}"
      publish_message(message)
    end

    private
    def publish_message(message)
      url = "http://localhost:18082/?message=#{URI.escape(message)}"
      open(url){|x| puts x}
    end
  end
end
