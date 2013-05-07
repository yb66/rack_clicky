require 'sinatra/base'
require 'haml'
require 'rack/clicky'


module Example
  class App < Sinatra::Base
    enable :inline_templates

    get "/" do
      haml :index
    end
    run if __FILE__ == $0
  end
  
  def self.app
    Rack::Builder.app do
      # or you could put this in the config.ru
      use Rack::Clicky, tracker: "000000"
      run App
    end
  end
end

__END__

@@ layout
!!!
%title Examples
%body
  = yield

@@ index
%p This is an example
%p Look at the source of this page to see the Clicky script has been injected.