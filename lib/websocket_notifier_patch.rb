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
      logger.info "===================="
      logger.info "calling websocket..."
      logger.info self.event_title
      logger.info self.event_description
      logger.info self.event_url
      logger.info "===================="
    end
  end
end
