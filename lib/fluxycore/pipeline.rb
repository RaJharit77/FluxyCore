module FluxyCore
  class Pipeline
    attr_reader :steps

    def initialize(&block)
      @steps = []
      instance_eval(&block) if block
    end

    def source(type, **options)
      @steps << { type: :source, source_type: type, options: options }
    end

    def transform(name = nil, **options, &block)
      @steps << {
        type: :transform,
        name: name,
        options: options,
        ruby_block: block
      }
    end

    def sink(type, **options)
      @steps << { type: :sink, sink_type: type, options: options }
    end

    def run
      data = nil

      steps.each do |step|
        case step[:type]
        when :source
          data = Source.load(step[:source_type], step[:options])
        when :transform
          data = Transform.apply(data, step[:name], step[:options], step[:ruby_block])
        when :sink
          Sink.write(data, step[:sink_type], step[:options])
          data = nil # après écriture, on ne propage plus
        end
      end
    end
  end
end