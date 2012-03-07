require 'has_hstore/string_hash'

module HasHstore

  class Hstore

    def initialize(hash_or_string = {})
      hash = case(hash_or_string)
      when Hash
        hash_or_string
      else
        self.class.from_string(hash_or_string)
      end
      @data = HasHstore::StringHash.new(hash)
    end

    # from Rails
    def to_s
      if !@data.nil?
        (@data.map do |key, value|
          "#{self.escape(key)}=>#{self.escape(value)}"
        end).join(',')
      else
        "NULL"
      end
    end
    
    def get(key)
      @data[key]
    end

    def set(key, value)
      @data[key] = value
    end

    def delete(key)
      @data.delete(key)
    end

    protected

    # from Rails
    def escape(value)
      if value.nil?
        'NULL'
      elsif value =~ /[=\s,>]/
        '"%s"' % value.gsub(/(["\\])/, '\\\\\1')
      elsif value == ""
        '""'
      else
        value.to_s.gsub(/(["\\])/, '\\\\\1')
      end
    end

    class << self

      # from Rails
      HSTORE_REGEX = begin
        quoted_string = /"[^"\\]*(?:\\.[^"\\]*)*"/
        unquoted_string = /(?:\\.|[^\s,])[^\s=,\\]*(?:\\.[^\s=,\\]*|=[^,>])*/
        /(#{quoted_string}|#{unquoted_string})\s*=>\s*(#{quoted_string}|#{unquoted_string})/
      end
      # from Rails
      def from_string(string)
        if string.nil?
          nil
        else
          tuples = string.to_s.scan(HSTORE_REGEX).map do |key, value|
            value = value.upcase == "NULL" ? nil : value.gsub(/^"(.*)"$/,'\1').gsub(/\\(.)/, '\1')
            key = key.gsub(/^"(.*)"$/,'\1').gsub(/\\(.)/, '\1')
            [ key, value ]
          end
          Hash[tuples]
        end
      end

    end

  end

end
