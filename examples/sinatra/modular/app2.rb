require 'sinatra/base'
require 'haml'
require 'rack/clicky'


module Example
  class App2 < Sinatra::Base
    enable :inline_templates
    use Rack::Clicky, tracker: "000000"

    get "/" do
      haml :index
    end
    run if __FILE__ == $0
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