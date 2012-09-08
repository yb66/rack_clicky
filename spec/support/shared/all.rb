

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

  def self.app( async=false )
    app = Rack::Builder.app do
      use Rack::Clicky, :tracker => TRACKER, :async => async
      x = lambda { |e|
        request = Rack::Request.new(e)
        response = if request.path == "/html"
          Rack::Response.new([HTML],200,{"Content-Type" => "text/html"}).finish
        elsif request.path == "/xhtml"
          Rack::Response.new([HTML],200,{"Content-Type" => "application/xhtml"}).finish
        elsif request.path == "/xml"
          Rack::Response.new([XML],200,{"Content-Type" => "application/xml"}).finish
        end
        response
      }
      run x
    end
  end # def app
end


shared_context "Application" do
  include Rack::Test::Methods
  let(:tracker){ Example::TRACKER }
end

shared_context "Synchronous" do
  let(:app){ Example.app( false ) }
end

shared_context "Asynchronous" do
  let(:app){ Example.app( true ) }
end

shared_examples_for "Any route" do
  subject { last_response }
  it { should be_ok }
end