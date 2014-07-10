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
  autoload :Grouping,      'togostanza/stanza/grouping'

  class Base
    extend ExpressionMap::Macro
    include Querying
    include Grouping

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
      Hashie::Mash.new(properties.resolve_all_in_parallel(self, params))
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

    def text_search(q)
      path = File.join(root, 'text_search.sparql.erb')
      # XXX 雑な実装やで...
      sparql = Tilt.new(path).render(Object.new, q: q)
      query("http://ep.dbcls.jp/sparql7ssd", sparql)
    end
  end
end
