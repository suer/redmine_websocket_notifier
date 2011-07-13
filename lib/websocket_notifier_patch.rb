module WebsocketNotifierPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      after_save :send_to_websocket    
    end
  end
  module InstanceMethods
    def send_to_websocket
      logger.info "calling websocket..."
    end
  end
end
