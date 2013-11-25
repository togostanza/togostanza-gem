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
  end
end
