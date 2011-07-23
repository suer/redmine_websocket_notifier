require 'rubygems'
require 'em-websocket'
require 'sinatra'

class WebsocketServer

  def initialize
    @connections = []
    @messages = []
  end

  def start_websocket_server
    EventMachine::WebSocket.start(:host => "127.0.0.1", :port => 18082, :debug => true) do |ws|
      ws.onopen { 
        @connections << ws
        @@messages.each {|prev| ws.send(prev)}
      }

      ws.onmessage {|msg|
        @messages.delete_if{|prev| msg == prev} 
        @messages.push(msg)
        @connections.each {|con| con.send(msg) unless con == ws} 
      }

      ws.onclose {
        @connections.delete_if{|con| con == ws} 
      }
    end
  end

  def start_web_server
    get '/message' do
      @messages << params[:activity]
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
