require 'rubygems'
require 'em-websocket'
require 'sinatra'

module WebsocketNotifier
  class WebsocketServer
    CONFIG_PATH = File.dirname(__FILE__) + '/../config/websocket.yml'
    DEFAULT_CONFIG = {'websocket' => {'redmine_side_port' => 4567, 'client_side_port' => 18082}}
    @@connections = []
    @@config = nil

    if File.exists?(CONFIG_PATH)
      open(CONFIG_PATH) {|f| @@config = YAML::load(f.read)}
    end
    @@config ||= DEFAULT_CONFIG
    @@config['websocket'] = DEFAULT_CONFIG['websocket'].merge(@@config['websocket'])
    def start_websocket_server
      port = @@config['websocket']['client_side_port']
      EventMachine::WebSocket.start(:host => "0.0.0.0", :port => port) do |connection|
        connection.onopen { @@connections << connection }
        connection.onmessage { }
        connection.onclose { @@connections.delete connection }
      end
    end

    def self.notify_message(message)
      @@connections.each {|con| con.send(message)} 
    end

    def self.config
      @@config
    end

    def start_web_server
      config = WebsocketNotifier::WebsocketServer::config
      port = config['websocket']['redmine_side_port']
      configure do
        set :port, port
      end
      get '/' do
        WebsocketNotifier::WebsocketServer::notify_message params[:message]
        ""
      end
    end
  end
end

if __FILE__ == $0
  server = WebsocketNotifier::WebsocketServer.new
  Thread.start do
    server.start_websocket_server
  end
  server.start_web_server
end
