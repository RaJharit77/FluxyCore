require 'csv'
require 'json'

module FluxyCore
  module Source
    def self.load(type, options)
      case type
      when :file
        path = options[:path]
        format = options[:format] || :csv
        case format
        when :csv
          CSV.read(path, headers: true).map(&:to_h)
        when :json
          JSON.parse(File.read(path))
        when :lines
          File.readlines(path, chomp: true).map { |l| { "line" => l } }
        else
          raise "Unknown file format: #{format}"
        end
      when :inline
        options[:data]
      else
        raise "Unknown source type: #{type}"
      end
    end
  end
end