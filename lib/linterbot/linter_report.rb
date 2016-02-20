require 'ostruct'
require 'json'

module Linterbot

  class LinterReport

    attr_accessor :report_file

    def initialize(report_file)
      @report_file = report_file
    end

    def linter_report
      @linter_report ||= JSON.parse(report_file_content)
    end

    def hints_by_file(base_path)
      hints_for_base_path(base_path).reduce(Hash.new) do |result, hint|
        hints_for_file = result[hint.file] ||= []
        hints_for_file << hint
        result
      end
    end

    private

      def hints_for_base_path(base_path)
        base_path = File.expand_path(base_path)
        base_path = base_path + "/" unless base_path.end_with?("/")
        hints = linter_report.map do |hint|
          hint = hint.merge("file_full_path" => hint["file"], "file" => hint["file"].sub(base_path, ""))
          OpenStruct.new(hint)
        end
      end

      def report_file_content
        if report_file.kind_of?(IO)
          report_file.read
        else
          File.read(report_file)
        end
      end

  end

end
