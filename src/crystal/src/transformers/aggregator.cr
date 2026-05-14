require "json"
require "option_parser"

module Transformers
  class Aggregator
    def self.run(args)
      group_by = ""
      sum_field = ""
      avg_field = ""
      count = false

      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: aggregate [options]"
        parser.on("--group-by FIELD", "Field to group by") { |v| group_by = v }
        parser.on("--sum FIELD", "Sum this field") { |v| sum_field = v }
        parser.on("--avg FIELD", "Average this field") { |v| avg_field = v }
        parser.on("--count", "Count records") { count = true }
      end

      if group_by.empty?
        STDERR.puts "Missing --group-by"
        exit 1
      end

      # Lecture de tous les objets JSON (un par ligne) depuis stdin
      rows = STDIN.each_line.map { |line| JSON.parse(line) }.to_a

      # Groupement
      grouped = rows.group_by { |row| row[group_by]?.try(&.to_s) || "null" }

      results = grouped.map do |key, group|
        obj = {} of String => JSON::Any
        obj[group_by] = JSON::Any.new(key)

        if count
          obj["count"] = JSON::Any.new(group.size.to_i64)
        end

        if !sum_field.empty?
          total = group.sum do |r|
            val = r[sum_field]?
            next 0.0 unless val
            case val
            when String
              val.to_f? || 0.0
            when Int
              val.to_f
            when Float
              val
            else
              0.0
            end
          end
          obj["sum_#{sum_field}"] = JSON::Any.new(total)
        end

        if !avg_field.empty?
          sum_values = group.sum do |r|
            val = r[avg_field]?
            next 0.0 unless val
            val.as_f? || val.as_i?.try(&.to_f) || 0.0
          end
          avg = group.size > 0 ? (sum_values / group.size) : 0.0
          obj["avg_#{avg_field}"] = JSON::Any.new(avg)
        end

        obj
      end

      # Sortie : un JSON par ligne
      results.each { |r| puts r.to_json }
    end
  end
end
