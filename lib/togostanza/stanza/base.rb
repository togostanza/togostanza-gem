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

module TogoStanza::Stanza
  autoload :ExpressionMap, 'togostanza/stanza/expression_map'
  autoload :Markdown,      'togostanza/stanza/markdown'
  autoload :Querying,      'togostanza/stanza/querying'

  class Base
    extend ExpressionMap::Macro
    include Querying

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

    class << self
      def id
        name.underscore.sub(/_stanza$/, '')
      end

      def root
        TogoStanza::Stanza.root.join(id)
      end
    end

    delegate :id, :root, to: 'self.class'

    def initialize(params = {})
      @params = params
    end

    attr_reader :params

    def context
      Hashie::Mash.new(properties.resolve_all_in_parallel(self, params))
    end

    def resource(name)
      resources.resolve(self, name, params)
    end

    def render
      path = root.join('template.hbs')

      Tilt.new(path.to_s).render(context)
    end

    def help
      path = root.join('help.md')

      TogoStanza::Markdown.render(path.read)
    end
  end
end
