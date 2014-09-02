require 'strscan'

module TogoStanza::Stanza
  class SearchQuery
    def initialize(query)
      @raw = query
    end

    attr_reader :raw

    def to_filter(method, var_name)
      "FILTER (#{to_clause(method, var_name)})"
    end

    def tokens
      @tokens ||= begin
        scanner = StringScanner.new(@raw)
        scanner.skip /\s+/

        parse(scanner)
      end
    end

    private

    def to_clause(method, var_name)
      case method.to_s
      when 'regex', 'contains'
        tokens.each_with_object('') {|token, acc|
          case token
          when :lparen
            acc << '('
          when :rparen
            acc << ')'
          when :or
            acc << ' || '
          when :and
            acc << ' && '
          else
            acc << "#{method}(?#{var_name}, #{token.inspect})"
          end
        }
      when 'bif_contains'
        clause = tokens.each_with_object('') {|token, acc|
          case token
          when :lparen
            acc << '('
          when :rparen
            acc << ')'
          when :or
            acc << ' OR '
          when :and
            acc << ' AND '
          else
            acc << token.inspect
          end
        }

        "bif:contains(?#{var_name}, '#{clause}')"
      else
        raise ArgumentError, method
      end
    end

    def parse(scanner, tokens = [])
      scanner.skip /\s+\z/

      return tokens if scanner.eos?

      if scanner.scan(/"((?:[^\\"]|\\.)*)"/)
        tokens << scanner[1].gsub(/\\(.)/, '\1')
      elsif scanner.scan(/\(\s*/)
        tokens << :lparen
      elsif scanner.scan(/\s*\)/)
        tokens << :rparen
      elsif scanner.scan(/\s*OR\s*/)
        tokens << :or
      elsif scanner.scan(/\s*AND\s*|\s+/)
        tokens << :and
      else
        tokens << scanner.scan(/\S+(?<!\))/)
      end

      parse(scanner, tokens)
    end
  end
end
