## Rack::Clicky ##

Rack Middleware to embed the Clicky (http://www.getclicky.com) tracking code.


### Installation.

    gem install rack_clicky

or if you're using Bundler:

    gem "rack_clicky", require: 'rack/clicky'
    
### Usage ###

    require 'rack/clicky'

    use Rack::Clicky, tracker: '000000'
    app = lambda { |env|
      output = '<html><body><p>Awesome Body</p></body></html>'
      [200, { 'Content-Type' => 'text/html' }, output] 
    }
    run app

There are more examples in the `examples` directory.

### Note on Patches/Pull Requests ###
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright and Licence ###

Copyright (c) 2010 Mark Turner. See LICENSE for details.
