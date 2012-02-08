Redmine Websocket Notifier
====================================
A Redmine plugin notifies activities to your browser.

Plugin Installation
------------------------------------

install gems

    $ sudo gem install socky-server --pre
    $ sudo gem install socky-client --pre
    $ sudo gem install thin

launch socky server

    $ thin -R vendor/plugins/redmine_websocket_notifier/config.ru -p 3001 -t 0 start

copy redmine_websocket_notifier plugin directory to $REDMINE_ROOT/vendor/plugin/

then, restart redmine.

Install Google Chrome Extension
------------------------------------
access to

    http://your.host.url/websocket_notifier/

then, follow guidance.

Requirements
------------------------------
* Redmine 1.3 or later
* Google Chrome

License
------------------------------
The MIT License (MIT)
Copyright (c) 2012 suer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
