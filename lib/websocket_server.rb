require 'rubygems'
require 'em-websocket'

connections = Array.new
messages = Array.new

EventMachine::WebSocket.start(:host => "127.0.0.1", :port => 18082, :debug => true) do |ws|
  ws.onopen { 
    connections.push(ws) unless connections.index(ws)
    messages.each {|prev| ws.send(prev)}
  }

  ws.onmessage {|msg|
    messages.delete_if{|prev| msg == prev} 
    messages.push(msg)
    connections.each {|con| con.send(msg) unless con == ws} 
  }

  ws.onclose {
    connections.delete_if{|con| con == ws} 
  }
end
