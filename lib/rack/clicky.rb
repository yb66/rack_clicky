# @see http://rack.rubyforge.org/doc/SPEC.html
module Rack

  # A Rack class for helping with the Clicky.com javascript and tracker code. The documentation for {Clicky#initialize} is the important bit.
  class Clicky

    # Produces the script.
    # This also caches the script, as unless the tracking code
    # and/or the async settings change, the script will remain
    # the same.
    def self.script
      @script ||= ( @async ? 
                    ASYNC_SCRIPT : 
                    SYNC_SCRIPT 
                  ).gsub!(/\{\{CODE\}\}/, @tracker)
    end


    # The script tags for the synchronous clicky script.
    SYNC_SCRIPT = <<EOTC 
<script src="//static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init({{CODE}}); }catch(e){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/{{CODE}}ns.gif" /></p></noscript>
EOTC

    # The script tags for the asynchronous clicky script.
    ASYNC_SCRIPT = <<STR
<script type="text/javascript">
  var clicky_site_ids = clicky_site_ids || [];
  clicky_site_ids.push({{CODE}});
  (function() {
    var s = document.createElement('script');
    s.type = 'text/javascript';
    s.async = true;
    s.src = '//static.getclicky.com/js';
    ( document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0] ).appendChild( s );
  })();
</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/{{CODE}}ns.gif" /></p></noscript>
STR

    # @param [String] tracker The tracking code.
    def self.tracker=( tracker )
      @tracker = tracker
    end

    # @return [String] The tracking code.
    def self.tracker
      @tracker
    end

    # @param [true,false] async True to use the asynchronous script, false for the synchronous script via CDN. Defaults to true (via the constructor).
    def self.async=( async )
      @async = async
    end

    # @return [true,false]
    def self.async
      @async
    end


    # Clears all the cached variables, tracker, async, and script.
    def self.clear_caches
      @async = nil
      @tracker = nil
      @script = nil
    end


    # Use the middleware, just pass in a tracker code.
    # The values given as options are cached.
    # @param [Proc] app
    # @param [Hash] options
    # @option [String] :tracker The tracking code. The app will fail if this is not supplied.
    # @option [true,false] :async Whether to use the asynchronous (default) or the synchronous script.
    # @example
    #   use Rack::Clicky, tracker: "000000" # async is the default
    #
    #   # for synchronous script
    #   use Rack::Clicky, tracker: "000000", async: false
    def initialize( app, options={} )
      fail ArgumentError, "Tracker must be set!" if options[:tracker].nil? || options[:tracker].empty?
      @app, @options  = app, options
      self.class.tracker  ||= @options[:tracker]
      self.class.async = @options.fetch(:async, true)
    end


    # @param [#call] env
    # @return [Array]
    def call( env )
      dup._call(env)
    end


    # Duplicated to make thread safe.
    # @see #call
    def _call( env )
      status, headers, response = @app.call(env)
      
      if should_inject_clicky?( status, headers )
        response = inject_script(response)
        headers['Content-Length'] = calc_content_length(headers, response).to_s if headers["Content-Length"]
      end

      [status, headers, response]
    end


    private


    # @param [Integer] status
    # @param [Hash] headers
    # @return [true,false]
    def should_inject_clicky?( status, headers )
      [200,201].any?{|sc| status == sc }  &&
      headers["Content-Type"]             &&
      ["text/html","application/xhtml"].any? {|ct| 
        headers["Content-Type"].include? ct 
      }
    end


    # Calculates the (new) content length.
    # @param [Hash] headers
    # @param [Rack::Response] response
    # @return [Integer]
    def calc_content_length( headers, response )
      length = response.to_ary.inject(0) { |len, part| 
        len + Rack::Utils.bytesize(part) 
      }
    end


    # Injects the script into the response.
    # @param [Rack::Response] response
    # @return [Array]
    def inject_script( response, body="" )
      response.each { |s| body << s.to_s }
      [ body.sub( %r{</body>}, "#{self.class.script}\n</body>") ]
    end

  end
end
