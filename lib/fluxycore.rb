require_relative 'fluxycore/pipeline'
require_relative 'fluxycore/source'
require_relative 'fluxycore/transform'
require_relative 'fluxycore/sink'
require_relative 'fluxycore/crystal_runner'

module FluxyCore
  def self.pipeline(&block)
    Pipeline.new(&block).run
  end
end