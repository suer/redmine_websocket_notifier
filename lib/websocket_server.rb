require 'rubygems'
require 'em-websocket'

class WebsocketServer
  def initialize
    @connections = []
    @messages = []
    start_websocket_server
  end

  def send_message(message, logger)
    logger.info "*****************"
    logger.info message
    logger.info"*****************"
    logger.info  @connections.size
    logger.info  @messages
    @messages.push(message)
    #@connections.each {|con| con.send(msg) unless con == ws} 
    @connections.each {|con| con.send(msg) } 
  end

  private
  def start_websocket_server
    @server_thread = Thread.new do
      EventMachine::WebSocket.start(:host => "127.0.0.1", :port => 18082, :debug => true) do |ws|
        ws.onopen { 
          puts @connections.class
          puts @connections.size
          @connections << ws unless @connections.index(ws)
          puts "================================"
          puts @connections.size
          puts "================================"
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
