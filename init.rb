require 'redmine'
require 'websocket_notifier_patch'
require 'dispatcher'
require 'em-websocket'

Dispatcher.to_prepare :redmine_websocket_notifer do
  ws = WebsocketServer.instance
  Redmine::Activity.default_event_types.each do |event|
    Redmine::Activity.providers[event].each do |clazz|
      clazz.constantize.send(:include, WebsocketNotifierPatch)
      clazz.constantize.websocket_server = ws
    end
  end
end

Redmine::Plugin.register :redmine_websocket_notifier do
  name 'Redmine Issues Websocket Notifier plugin(under construction...)'
  author 'suer'
  description 'issues websocket notifier'
  version '0.0.1'
  url 'https://github.com/suer/redmine_websocket_notifier'
  author_url 'http://d.hatena.ne.jp/suer'
end


