require 'rubygems'
require 'em-websocket'
require 'sinatra'

class WebsocketServer
  @@connections = []

  def start_websocket_server
    EventMachine::WebSocket.start(:host => "127.0.0.1", :port => 18082, :debug => true) do |ws|
      ws.onopen { @@connections << ws }
    end
  end

  def self.notify_message(message)
    @@connections.each {|con| con.send(message)} 
  end

  def start_web_server
    get '/message' do
      WebsocketServer::notify_message params[:activity]
      ""
    end
  end
end

if __FILE__ == $0
  server = WebsocketServer.new
  Thread.start do
    server.start_websocket_server
  end
  server.start_web_server
end
