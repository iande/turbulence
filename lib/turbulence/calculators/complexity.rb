require 'stringio'
require 'flog'
class Turbulence
  module Calculators
    class Complexity
      def initialize opts={}
      end      
      def flogger
        @flogger ||= Flog.new(:continue => true)
      end
      def for_these_files(files)
        files.each do |filename|
          yield filename, score_for_file(filename)
        end
      end

      def score_for_file(filename)
        flogger.flog filename
        reporter = Reporter.new
        flogger.report(reporter)
        reporter.score
      end
      
      def to_s
        self.class.to_s
      end

      class Reporter < ::StringIO
        SCORE_LINE_DETECTOR = /^\s+([^:]+).*flog total$/
        def score
          Float(string.scan(SCORE_LINE_DETECTOR).flatten.first)
        end
      end
    end
  end
end
