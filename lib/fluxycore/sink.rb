require 'csv'
require 'json'

module FluxyCore
  module Sink
    def self.write(data, type, options)
      case type
      when :csv
        CSV.open(options[:path] || options['path'], "w") do |csv|
          unless data.empty?
            csv << data.first.keys
            data.each { |row| csv << row.values }
          end
        end
      when :json
        File.write(options[:path] || options['path'], JSON.pretty_generate(data))
      when :stdout
        puts JSON.pretty_generate(data)
      else
        raise "Unknown sink type: #{type}"
      end
    end
  end
end