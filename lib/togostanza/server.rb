require 'sinatra/base'
require 'sinatra/reloader'

module TogoStanza
  class Server < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      'hello'
    end
  end
end
