require 'rubygems'
require 'em-websocket'
require 'singleton'

class WebsocketServer
  include Singleton

  def initialize
    @connections = []
    @messages = []
    @connection_queue = Queue.new
    @message_queue = Queue.new
    start_websocket_server
  end

  def send_message(message, logger)
    until @connection_queue.empty?
      con = @connection_queue.pop
      @connections << con unless @connections.include?(con)
    end
    @messages.push(message)
    @connections.each {|con| con.send(message) } 
  end

  private
  def start_websocket_server
    @server_thread = Thread.new do
      EventMachine::WebSocket.start(:host => "127.0.0.1", :port => 18082, :debug => true) do |ws|
        ws.onopen { 
          @connection_queue << ws
          @messages.each {|prev| ws.send(prev)}
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
  end
end
