require 'redmine'
require 'websocket_notifier_patch'
require 'dispatcher'
Dispatcher.to_prepare :redmine_websocket_notifer do
  require_dependency 'issue'
  Issue.send(:include, WebsocketNotifierPatch)
end

Redmine::Plugin.register :redmine_websocket_notifier do
  name 'Redmine Issues Websocket Notifier plugin(under construction...)'
  author 'suer'
  description 'issues websocket notifier'
  version '0.0.1'
  url 'https://github.com/suer/redmine_websocket_notifier'
  author_url 'http://d.hatena.ne.jp/suer'
end
