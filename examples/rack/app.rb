require 'rack/clicky'

module Example
  HTML = <<-EOHTML
  <html>
    <head>
      <title>Sample Page</title>
    </head>
    <body>
      <h2>Rack::Clicky Test</h2>
      <p>This is more test html</p>
    </body>
  </html>
  EOHTML

  XML = <<-EOXML
  <?xml version="1.0" encoding="ISO-8859-1"?>
  <user>
    <name>Mark Turner</name>
    <age>Unknown</age>
  </user>
  EOXML

  TRACKER = "000000"

  def self.app( async=false, link=true )
    Rack::Builder.app do
      # the :async => async option is there to make it easier to
      # test, but if you leave that option entirely off
      # you'll get the async script by default.
      use Rack::Clicky, :tracker => TRACKER, :async => async, :link => link

      # Here, there are 3 paths, each to try a different
      # flavour of output.
      run lambda {|env|
        request = Rack::Request.new(env)
        response = if request.path == "/"
          Rack::Response.new(["<html><body><p>Please look at <a href='/html'>/html</a>, <a href='/xhtml'>/xhtml</a> and <a href='/xml'>/xml</a></p></body></html>"],200,{"Content-Type" => "text/html"})
        elsif request.path == "/html"
          Rack::Response.new([HTML],200,{"Content-Type" => "text/html"})
        elsif request.path == "/xhtml"
          Rack::Response.new([HTML],200,{"Content-Type" => "application/xhtml"})
        elsif request.path == "/xml"
          Rack::Response.new([XML],200,{"Content-Type" => "application/xml"})
        else
          Rack::Response.new "Not found", 404
        end
        response.finish
      }
    end
  end # def app
end