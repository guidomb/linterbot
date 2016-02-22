module Linterbot

  class PullRequestAnalysisResult

    attr_accessor :comments

    def initialize(comments)
      @comments = comments
    end

    def approved?
      comments.empty?
    end

    def violations?
      comments.count > 0
    end

    def violations_count
      comments.count
    end

    def summary
      if violations?
        "Total linter violations in pull request: #{comments.count}\n" +
        "Serious: #{serious_violations.count}\n" +
        "Warnings: #{warning_violations.count}"
      else
        ":+1: There are no linter violations."
      end
    end

    def serious_violations?
      serious_violations.count > 0
    end

    private

      def violations_with_severity(severity)
        comments.select { |violation| violation.severity == severity }
      end

      def serious_violations
        @serious_violations ||= violations_with_severity("Serious")
      end

      def warning_violations
        @warning_violations ||= violations_with_severity("Warning")
      end

  end

end
