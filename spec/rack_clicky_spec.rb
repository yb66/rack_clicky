# encoding: UTF-8

require 'spec_helper'
require_relative "../lib/rack/clicky.rb"

describe Rack::Clicky do
  describe "Embedding clicky" do
    include_context "Application"
    let(:link) { <<STR
<a title="Real Time Web Analytics" href="http://clicky.com/000000"><img alt="Real Time Web Analytics" src="//static.getclicky.com/media/links/badge.gif" border="0" /></a>
STR
    }
    let(:async_script) { s = <<STR
<script type=\"text/javascript\">
  var clicky_site_ids = clicky_site_ids || [];
  clicky_site_ids.push(000000);
  (function() {
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.async = true;
    s.src = '//static.getclicky.com/js';
    ( document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0] ).appendChild( s );
  })();
</script>
<noscript><p><img alt=\"Clicky\" width=\"1\" height=\"1\" src=\"//in.getclicky.com/000000ns.gif\" /></p></noscript>

</body>
STR
      s.strip!
    }
    let(:sync_script) { s= <<STR
<script src="//static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init(000000); }catch(e){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/000000ns.gif" /></p></noscript>

</body>
STR
      s.strip!
    }

    describe "Synchronous" do
      before :all do
        Example.app.class.clear_caches
      end
      context "Given a false regarding async" do
        include_context "Synchronous"
        let(:script) { "#{link}#{sync_script}" }
        context "a 200 status and html served" do
          before{ get "/html", {},{"HTTP_ACCEPT" => "text/html" } }
          it_should_behave_like "Any route"
          subject { last_response.body }
          it { should include script }
          describe "async setting" do
            subject { app.class.async }      
            it { should be_false }
          end
        end  
        context "a 200 status and xhtml served" do
          before{ get "/xhtml", {},{"HTTP_ACCEPT" => "application/xhtml+xml" } }
          it_should_behave_like "Any route"
          subject { last_response.body }
          it { should include script }
          describe "async setting" do
            subject { app.class.async }      
            it { should be_false }
          end
        end 
        context "a 200 status and xml served" do
          before{ get "/xml", {},{"HTTP_ACCEPT" => "application/xml" } }
          it_should_behave_like "Any route"
          subject { last_response.body }
          it { should_not include script }
          describe "async setting" do
            subject { app.class.async }      
            it { should be_false }
          end
        end
  
      end
    end

    describe "Asynchronous" do
      before :all do
        Example.app.class.clear_caches
      end
      context "Given a true regarding async" do
        include_context "Asynchronous"
        let(:script) { "#{link}#{async_script}" }
        context "a 200 status and html served" do
          describe "async setting" do
            subject { app.class.async }      
            it { should be_true }
          end
          before{ get "/html", {},{"HTTP_ACCEPT" => "text/html" } }
          it_should_behave_like "Any route"
          subject { last_response.body }
          it { should include script }
        end  
        context "a 200 status and xhtml served" do
          describe "async setting" do
            subject { app.class.async }      
            it { should be_true }
          end
          before{ get "/xhtml", {},{"HTTP_ACCEPT" => "application/xhtml+xml" } }
          it_should_behave_like "Any route"
          subject { last_response.body }
          it { should include script }
        end 
        context "a 200 status and xml served" do
          describe "async setting" do
            subject { app.class.async }      
            it { should be_true }
          end
          before{ get "/xml", {},{"HTTP_ACCEPT" => "application/xml" } }
          it_should_behave_like "Any route"
          subject { last_response.body }
          it { should_not include script }
        end
  
      end
    end

    describe "Without link" do
      before :all do
        Example.app.class.clear_caches
      end
      include_context "Without link"
      let(:script) { async_script }
      context "a 200 status and html served" do
        before{ get "/html", {},{"HTTP_ACCEPT" => "text/html" } }
        it_should_behave_like "Any route"
        subject { last_response.body }
        it { should include script }
        it { should_not include link }
      end  
    end
  end

end
