require "./transformers/*"

module FluxyTransformer
  VERSION = "0.1.0"

  def self.run
    if ARGV.empty?
      puts "Usage: fluxy_transformer <command> [options]"
      exit 1
    end

    command = ARGV[0]
    args = ARGV[1..]

    case command
    when "aggregate"
      Transformers::Aggregator.run(args)
    when "log-parse"
      Transformers::LogParser.run(args)
    else
      STDERR.puts "Unknown command: #{command}"
      exit 1
    end
  end
end

FluxyTransformer.run