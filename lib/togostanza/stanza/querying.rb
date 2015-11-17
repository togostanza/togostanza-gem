require 'sparql/client'

module TogoStanza::Stanza
  module Querying
    MAPPINGS = {
      togogenome: 'http://togogenome.org/sparql'
    }

    def query(endpoint, sparql)
      client = SPARQL::Client.new(MAPPINGS[endpoint] || endpoint)

      #Rails.logger.debug "SPARQL QUERY: \n#{sparql}"

      client.query(sparql).map {|binding|
        binding.each_with_object({}) {|(name, term), hash|
          hash[name] = term.to_s
        }
      }
    end
  end
end
