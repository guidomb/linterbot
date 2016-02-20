require 'forwardable'

module Linterbot

  class Runner
    extend Forwardable

    def_delegators :@configuration,
      :project_base_path,
      :github_client,
      :linter_report_file,
      :commenter_class,
      :approver_class

    def initialize(configuration)
      @configuration = configuration
    end

    def run(repository, pull_request_number)
      pull_request = new_pull_request(repository, pull_request_number)
      mark_pull_request_status_as_pending(pull_request)
      analyze(pull_request)
    end

    private

      def linter_report
        @linter_report ||= LinterReport.new(linter_report_file)
      end

      def analyze(pull_request)
        analyzer = new_pull_request_analyzer(pull_request)
        handler = new_result_handler(pull_request)
        result = analyzer.analyze(project_base_path)
        handler.handle(result)
      rescue Exception => exception
        mark_pull_request_status_as_error(pull_request)
        raise exception
      end

      def new_pull_request(repository, pull_request_number)
        PullRequest.new(repository, pull_request_number, github_client)
      end

      def new_commenter(pull_request)
        commenter_class.new(pull_request.repository, pull_request.pull_request_number, github_client)
      end

      def new_pull_request_analyzer(pull_request)
        PullRequestAnalyzer.new(linter_report, pull_request)
      end

      def new_result_handler(pull_request)
        commenter = new_commenter(pull_request)
        ResultHandler.new(pull_request, commenter, approver)
      end

      def approver
        @approver ||= approver_class.new(github_client)
      end

      def mark_pull_request_status_as_pending(pull_request)
        approver.pending(pull_request.repository, pull_request.newest_commit.sha)
      end

      def mark_pull_request_status_as_error(pull_request)
        approver.error(pull_request.repository, pull_request.newest_commit.sha)
      end

  end

end
