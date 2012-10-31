# webkit_remote

Ruby gem for driving
[Google Chrome](https://www.google.com/chrome/) and possibly other
WebKit-based browsers via the
[WebKit remote debugging protocol](https://www.webkit.org/blog/1875/announcing-remote-debugging-protocol-v1-0/).


## Requirements

The gem is tested against the OSX and Linux builds of Google Chrome. The only
platform-dependent functionality is launching and shutting down the browser
process, everything else should work for any WebKit-based browser that
implements the remote debugging protocol.


## Installation

Use RubyGems.

```bash
gem install webkit_remote
```


## Usage

This section only showcases a few features. Read the
[YARD docs](http://rdoc.info/github/pwnall/webkit_remote)
to see everything this gem has to offer.

### Session Setup

```ruby
client = WebkitRemote.local
```

launches a separate instance of Google Chrome that is not connected to your
profile, and sets up a connection to it. Alternatively,


```ruby
client = WebkitRemote.remote host: 'phone-ip-here', port: 9222
```

connects to a remote WebKit instance
[running on a phone](https://developers.google.com/chrome/mobile/docs/debugging).

### Load a Page

```ruby
client.page_events = true
client.navigate_to 'http://translate.google.com'
client.wait_for type: WebkitRemote::Event::PageLoaded
```

### Run JavaScript

Evaluate some JavaScript.

```ruby
element = client.remote_eval 'document.querySelector("[name=text]")'
```

Take a look at the result.

```ruby
element.js_class_name
element.description
element.properties[:tagName].value
element.properties[:tagName].writable?
```

Pass an object to some JavaScript code.

```ruby
js_code = <<END_JS
function(element, value) {
  element.value = value;
  return "Check the browser window";
}
END_JS
client.remote_eval('window').bound_call js_code, element, '你好'
```

Finally, release the JavaScript objects that the debugger is holding onto.

```ruby
element.group.release_all
```

### Clean Up

```ruby
client.close
```

closes the debugging connection and shuts down the Google Chrome instance.


## Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Victor Costan. See LICENSE.txt for further details.
