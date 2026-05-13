require 'open3'
require 'json'

module FluxyCore
  class CrystalRunner
    BINARY = File.expand_path("../../bin/fluxy_transformer", __dir__)

    def self.run(command, input_data, input_format: :json)
      cmd = [BINARY] + command

      stdin_data = if input_format == :json
                     input_data.map { |row| JSON.generate(row) }.join("\n")
                   else
                     input_data.join("\n")
                   end

      stdout_str, stderr_str, status = Open3.capture3(*cmd, stdin_data: stdin_data)

      unless status.success?
        raise "Crystal transformer failed: #{stderr_str}"
      end

      # output est du JSON lignes
      stdout_str.strip.lines.map { |l| JSON.parse(l) }
    rescue JSON::ParserError => e
      raise "Invalid JSON from Crystal transformer: #{e.message}"
    end
  end
end