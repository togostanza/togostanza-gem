require 'sparql/client'

module TogoStanza::Stanza
  module Querying
    MAPPINGS = {
      togogenome: 'http://ep.dbcls.jp/sparql7os',
      uniprot:    'http://ep.dbcls.jp/sparql7os',
      go:         'http://ep.dbcls.jp/sparql7os'
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

    def uniprot_url_from_togogenome(gene_id)
      # refseq の UniProt
      # slr1311 の時 "http://purl.uniprot.org/refseq/NP_439906.1"
      query(:togogenome, <<-SPARQL.strip_heredoc).first[:up]
        PREFIX insdc: <http://insdc.org/owl/>
        PREFIX idorg: <http://rdf.identifiers.org/database/>
        PREFIX dct:   <http://purl.org/dc/terms/>

        SELECT DISTINCT ?up
        WHERE {
          GRAPH <http://togogenome.org/graph/> {
            <http://togogenome.org/refseq/> dct:isVersionOf ?g .
          }

          GRAPH ?g {
            ?s insdc:feature_locus_tag "#{gene_id}" .
            ?s rdfs:seeAlso ?np .
            ?s rdfs:seeAlso ?xref .
            ?np rdf:type idorg:Protein .
            BIND (STRAFTER(STR(?np), "ncbiprotein/") AS ?npid)
            BIND (IRI(CONCAT("http://purl.uniprot.org/refseq/", ?npid)) AS ?up)
          }
        }
      SPARQL
    end
  end
end
