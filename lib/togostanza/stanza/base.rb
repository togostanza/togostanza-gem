require 'active_support/core_ext/module/delegation'
require 'flavour_saver'
require 'hashie/mash'

FS.register_helper :adjust_iframe_height_script do
  <<-HTML.strip_heredoc.html_safe
    <script>$(function() {
      height = this.body.offsetHeight + 30;
      parent.postMessage(JSON.stringify({height: height, id: name}), "*");
    });</script>
  HTML
end

FS.register_helper :data_download do
  this.delete(:css_uri)
  json =  this.to_json

  <<-HTML.strip_heredoc.html_safe
    <script src="/stanza/assets/FileSaver.js"></script>
    <script src="/stanza/assets/canvas-toBlob.js"></script>

    <script type="text/javascript" src="http://canvg.googlecode.com/svn/trunk/rgbcolor.js"></script>
    <script type="text/javascript" src="http://canvg.googlecode.com/svn/trunk/StackBlur.js"></script>
    <script type="text/javascript" src="http://canvg.googlecode.com/svn/trunk/canvg.js"></script>

    <script>$(function() {
      $('body').append("<div id='stanza_buttons'></div>");
      $("div#stanza_buttons").append("<button id='download_json' class='btn btn-mini' href='#'><i class='icon-font'></i> Save json</button>");
      $("div#stanza_buttons").append("<button id='download_svg' class='btn btn-mini' href='#'><i class='icon-font'></i> Save image(svg)</button>");
      $("div#stanza_buttons").append("<button id='download_image' class='btn btn-mini' href='#'><i class='icon-picture'></i> Save image(png)</button>");

      $("body").append("<div style='display: none;'><canvas id='drawarea'></canvas></div>");

      $("#download_json").on("click",function(){
        var blob = new Blob([JSON.stringify(#{json}, "", "\t")], {type: "text/plain;charset=utf-8"});
        saveAs(blob, "data.json");
      });

      $("#download_svg").on("click",function(){
        if ($("svg")[0]) {
          var svgText = $("svg")[0].outerHTML;
          var blob = new Blob([svgText], {type: "image/svg+xml;charset=utf-8"});
          saveAs(blob, "data.svg");
        } else {
          // TODO...
          alert('Sorry');
        }
      });

      $("#download_image").on("click",function(){
        if ($("svg")[0]) {
          var svgText = $("svg")[0].outerHTML;
          canvg('drawarea', svgText);

          var canvas = $("#drawarea")[0];

          canvas.toBlob(function(blob) {
            saveAs(blob, "image.png");
          }, "image/png");
        } else {
          // TODO...
          alert('Sorry');
        }
      });
    });
    </script>
  HTML
end

module TogoStanza::Stanza
  autoload :ExpressionMap, 'togostanza/stanza/expression_map'
  autoload :Grouping,      'togostanza/stanza/grouping'
  autoload :Markdown,      'togostanza/stanza/markdown'
  autoload :Querying,      'togostanza/stanza/querying'
  autoload :TextSearch,    'togostanza/stanza/text_search'

  class Context < Hashie::Mash
    def respond_to_missing?(*)
      # XXX It looks ugly, but we need use not pre-defined properties
      true
    end
  end

  class Base
    extend ExpressionMap::Macro
    include Querying
    include Grouping
    include TextSearch

    define_expression_map :properties
    define_expression_map :resources

    property :css_uri do |css_uri|
      if css_uri
        css_uri.split(',')
      else
        %w(
          //cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.2.2/css/bootstrap.min.css
          /stanza/assets/stanza.css
        )
      end
    end

    class_attribute :root

    def self.id
      to_s.underscore.sub(/_stanza$/, '')
    end

    delegate :id, to: 'self.class'

    def initialize(params = {})
      @params = params
    end

    attr_reader :params

    def context
      Context.new(properties.resolve_all_in_parallel(self, params))
    end

    def resource(name)
      resources.resolve(self, name, params)
    end

    def render
      path = File.join(root, 'template.hbs')

      Tilt.new(path).render(context)
    end

    def help
      path = File.join(root, 'help.md')

      TogoStanza::Markdown.render(File.read(path))
    end
  end
end
