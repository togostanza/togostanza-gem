module TogoStanza::Stanza
  module Querying
    MAPPINGS = {
      togogenome: 'http://lod.dbcls.jp/openrdf-sesame5l/repositories/togogenome',
      uniprot:    'http://lod.dbcls.jp/openrdf-sesame5l/repositories/cyano',
      go:         'http://lod.dbcls.jp/openrdf-sesame5l/repositories/go'
    }

    def query(endpoint, sparql)
      client = SPARQL::Client.new(MAPPINGS[endpoint] || endpoint)

      Rails.logger.debug "SPARQL QUERY: \n#{sparql}"

      client.query(sparql).map {|binding|
        binding.each_with_object({}) {|(name, term), hash|
          hash[name] = term.to_s
        }
      }
    end

    def uniprot_url_from_togogenome(gene_id)
      # refseq の UniProt
      # slr1311 の時 "http://purl.uniprot.org/refseq/NP_439906.1"
      query(:togogenome, <<-SPARQL).first[:up]
        PREFIX insdc: <http://rdf.insdc.org/>

        SELECT ?up
        WHERE {
          ?s insdc:feature_locus_tag "#{gene_id}" .
          ?s rdfs:seeAlso ?np .
          ?np rdf:type insdc:Protein .
          ?np rdfs:seeAlso ?up .
        }
      SPARQL
    end
  end
end
