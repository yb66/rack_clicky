require 'sinatra'
require 'haml'
require 'rack/clicky'

use Rack::Clicky, tracker: "000000"

get "/" do
  haml :index
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