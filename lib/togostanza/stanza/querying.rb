require 'sparql/client'
require 'flavour_saver'

module TogoStanza::Stanza
  module Querying
    MAPPINGS = {
      togogenome: 'http://togogenome.org/sparql'
    }

    def query(endpoint, text_or_filename, **options)
      path = File.join(root, 'sparql', text_or_filename)

      if File.exist?(path)
        data = OpenStruct.new params
        text_or_filename = Tilt.new(path).render(data)
      end

      client = SPARQL::Client.new(MAPPINGS[endpoint] || endpoint, method: 'get')

      result = client.query(text_or_filename, **{content_type: 'application/sparql-results+json'}.merge(options)).map {|binding|
        binding.each_with_object({}) {|(name, term), hash|
          hash[name] = term.to_s
        }
      }
      client.close
      result
    end
  end
end
