require 'togostanza-server'

class DummyServer < TogoStanza::Server
  set :root, __dir__
end
