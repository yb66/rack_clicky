require_relative "../../../examples/rack/app.rb"


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

shared_context "Without link" do
  let(:app){ Example.app( true, false ) }
end

shared_examples_for "Any route" do
  subject { last_response }
  it { should be_ok }
end