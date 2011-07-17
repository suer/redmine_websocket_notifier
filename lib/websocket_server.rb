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
    logger.info  @connection_queue.size
    until @connection_queue.empty?
      con = @conection_queue.pop
      @connections << con unless @connections.include?(con)
    end
    logger.info "*****************"
    logger.info message
    logger.info "*****************"
    logger.info  @connections.size
    logger.info  @messages
    @messages.push(message)
    #@@connections.each {|con| con.send(msg) unless con == ws} 
    #@@connections.each {|con| con.send(msg) } 
  end

  private
  def start_websocket_server
    @server_thread = Thread.new do
      EventMachine::WebSocket.start(:host => "127.0.0.1", :port => 18082, :debug => true) do |ws|
        ws.onopen { 
          @connection_queue << ws
          puts "================================"
          puts @connection_queue.size
          puts "================================"
          @messages.each {|prev| ws.send(prev)}
        }

        ws.onmessage {|msg|
          @messages.delete_if{|prev| msg == prev} 
          @messages.push(msg)
          @connections.each {|con| con.send(msg) unless con == ws} 
        }

        ws.onclose {
          puts "================================"
          puts "close!!!!!!!!!!!!!!!"
          puts "================================"
          @connections.delete_if{|con| con == ws} 
        }
      end
    end
  end
end
