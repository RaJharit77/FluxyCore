module FluxyCore
  module Transform
    def self.apply(data, name, options, ruby_block)
      if ruby_block
        # transformation Ruby pure
        data.map(&ruby_block)
      elsif name
        case name
        when :aggregate
          raise "Aggregation requires :group_by option" unless options[:group_by]
          cmd = ["aggregate", "--group-by", options[:group_by].to_s]
          cmd += ["--sum", options[:sum].to_s] if options[:sum]
          cmd += ["--avg", options[:avg].to_s] if options[:avg]
          cmd += ["--count"] if options[:count]
          CrystalRunner.run(cmd, data, input_format: :json)

        when :parse_logs
          format = options[:format] || :combined
          cmd = ["log-parse", "--format", format.to_s]
          # data est actuellement un tableau de Hash avec "line"
          lines = data.map { |row| row["line"] }
          CrystalRunner.run(cmd, lines, input_format: :text)

        else
          raise "Unknown transform: #{name}"
        end
      else
        data # pas de transformation
      end
    end
  end
end