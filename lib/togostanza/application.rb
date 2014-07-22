require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/reloader'
require 'haml'

module TogoStanza
  class Application < Sinatra::Base
    set :root,       File.expand_path('../../..', __FILE__)
    set :haml,       escape_html: true
    set :protection, except: [:json_csrf, :frame_options]

    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      def path(*paths)
        prefix = env['SCRIPT_NAME']

        [prefix, *paths].join('/').squeeze('/')
      end
    end

    get '/' do
      haml :index
    end

    get '/:id.json' do |id|
      json Stanza.find(id).new(params).context
    end

    get '/:id' do |id|
      Stanza.find(id).new(params).render
    end

    get '/:id/resources/:resource_id' do |id, resource_id|
      value = Stanza.find(id).new(params).resource(resource_id)

      json resource_id => value
    end

    get '/:id/help' do |id|
      @stanza = Stanza.find(id).new

      render :html, @stanza.help, layout_engine: :haml
    end

    get '/:id/text_search' do |id|
      stanza_uri = request.env['REQUEST_URI'].gsub(/\/text_search.*/, '')
      @stanza = Stanza.find(id).new

      begin
        identifiers = @stanza.text_search(params[:q]).map {|param_hash|
          parameters = param_hash.map {|k, v| "#{k}=#{v}" }.join('&')
          "#{stanza_uri}?#{parameters}"
        }

        json enabled: true, count: identifiers.size, urls: identifiers
      rescue NotImplementedError
        json enabled: false, count: 0, urls: []
      end
    end
  end
end
