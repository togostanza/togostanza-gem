module TogoStanza::Stanza
  module Grouping
    module_function

    def grouping(rows, *keys)
      normalized_keys = keys.inject([]) {|acc, key|
        acc + (key.is_a?(Hash) ? key.to_a : [[key, key]])
      }

      _grouping(rows, *normalized_keys)
    end

    def _grouping(rows, *keys)
      (k1, a1), (k2, a2) = keys

      return rows.map {|row| row[k1] } if keys.size == 1

      rows.group_by {|row|
        k1.is_a?(Array) ? row.values_at(*k1) : row[k1]
      }.map {|vs, rs|
        {
          a1 => vs,
          a2 => _grouping(rs, *keys.drop(1))
        }
      }
    end
  end
end
