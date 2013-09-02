require 'redcarpet'

module TogoStanza
  module Markdown
    class << self
      def render(source)
        INSTANCE.render(source)
      end
    end

    class Renderer < Redcarpet::Render::HTML
      def table(header, body)
        <<-HTML.strip_heredoc
          <table class="table">
            #{header}
            #{body}
          </table>
        HTML
      end
    end

    RENDERER = Renderer.new(
      hard_wrap:       true,
      safe_links_only: true,
      with_toc_data:   true
    )

    INSTANCE = Redcarpet::Markdown.new(RENDERER,
      autolink:            true,
      fenced_code_blocks:  true,
      lax_spacing:         true,
      no_intra_emphasis:   true,
      space_after_headers: true,
      strikethrough:       true,
      superscript:         false,
      tables:              true
    )
  end
end
