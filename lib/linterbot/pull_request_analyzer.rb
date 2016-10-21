module Linterbot

  class PullRequestAnalyzer

    attr_accessor :pull_request
    attr_accessor :linter_report

    def initialize(linter_report, pull_request)
      @pull_request = pull_request
      @linter_report = linter_report
    end

    def analyze(base_path)
      comments = hints_in_pull_request(base_path)
        .each_pair
        .reduce([]) do |comments, (filename, hints)|
          comments + generate_comments(filename, hints)
        end
      PullRequestAnalysisResult.new(comments)
    end

    private

      def hints_in_pull_request(base_path)
        linter_report.hints_by_file(base_path)
          .select { |filename, hints| analyze_file?(filename) }
      end

      def analyze_file?(filename)
        added_and_modified_files.include?(filename)
      end

      def added_and_modified_files
        pull_request.added_and_modified_files
      end

      def generate_comments(filename, hints)
        pull_request_file_patch = pull_request.patch_for_file(filename)
        commits = pull_request.commits_for_file(filename)
        commits.map do |commit|
          CommentGenerator.new(filename, commit, pull_request_file_patch, commits.length)
            .generate_comments(hints)
        end.flatten
      end

  end

end
