require 'socky/server'

options = {
  :debug => true,
  :applications => {
    :redmine => 'secret',
  }
}

map '/websocket' do
  run Socky::Server::WebSocket.new options
end

map '/http' do
  run Socky::Server::HTTP.new options
end
