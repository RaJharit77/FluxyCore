require "json"
require "option_parser"

module Transformers
  class LogParser
    # Format Apache combined
    COMBINED_REGEX = /^(\S+) (\S+) (\S+) \[([^\]]+)\] \"(\S+)\s?(\S+)?\s?(\S+)?\" (\d{3}) (\S+) \"([^\"]*)\" \"([^\"]*)\"/

    def self.run(args)
      format = "combined"

      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: log-parse [options]"
        parser.on("--format FORMAT", "Log format (combined)") { |v| format = v }
      end

      regex = case format
              when "combined"
                COMBINED_REGEX
              else
                STDERR.puts "Unsupported format: #{format}"
                exit 1
              end

      STDIN.each_line do |line|
        if m = line.match(regex)
          fields = {
            "ip"          => m[1],
            "ident"       => m[2],
            "user"        => m[3],
            "time"        => m[4],
            "method"      => m[5],
            "path"        => m[6],
            "protocol"    => m[7],
            "status"      => m[8].to_i,
            "size"        => m[9],
            "referer"     => m[10],
            "user_agent"  => m[11],
          }
          puts fields.to_json
        else
          # ligne ignorée, on pourrait écrire dans STDERR
          # STDERR.puts "No match: #{line}"
        end
      end
    end
  end
end