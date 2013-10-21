$LOAD_PATH.unshift *Dir.glob(File.expand_path('../*_stanza/lib', __FILE__))

require 'togostanza'
require 'foo_stanza'
require 'bar_stanza'

class DummyApp < TogoStanza::Application
end
