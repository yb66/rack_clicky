# encoding: UTF-8

require 'spec_helper'
require_relative "../lib/rack_clicky.rb"

describe RackClicky do
  describe "Embedding clicky" do
    include_context "Application"
    let(:async_script) { <<STR
<script type=\"text/javascript\">\n      var clicky_site_ids = clicky_site_ids || [];\n      clicky_site_ids.push(000000);\n      (function() {\n        var s = document.createElement('script');\n        s.type = 'text/javascript';\n        s.async = true;\n        s.src = '//static.getclicky.com/js';\n        ( document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0] ).appendChild( s );\n      })();\n      </script>\n      <noscript><p><img alt=\"Clicky\" width=\"1\" height=\"1\" src=\"//in.getclicky.com/000000ns.gif\" /></p></noscript>\n\n</body>
STR
    }
    let(:sync_script) { <<STR
<script src="http://static.getclicky.com/js" type="text/javascript"></script>
    <script type="text/javascript">clicky.init(000000);</script>
    <noscript><p><img alt="Clicky" width="1" height="1" src="http://in.getclicky.com/000000ns.gif" /></p></noscript>

</body>
STR
    }

    describe "Synchronous" do
      before :all do
        Example.app.class.clear_caches
      end
      context "Given a false regarding async" do
        include_context "Synchronous"
        let(:script) { sync_script }
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
        let(:script) { async_script }
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

  end

end
