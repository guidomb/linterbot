module Linterbot

  class ResultHandler

    attr_accessor :pull_request
    attr_accessor :github_client
    attr_accessor :commenter
    attr_accessor :approver

    def initialize(pull_request, commenter, approver)
      @pull_request = pull_request
      @commenter = commenter
      @approver = approver
    end

    def handle(result)
      result.comments.each { |comment| commenter.publish_comment(comment) }
      commenter.publish_summary(result.summary)
      if result.serious_violations?
        reject_pull_request(result.serious_violations_count)
      else
        approve_pull_request
      end
    end

    private

      def approve_pull_request
        approver.approve(pull_request.repository, pull_request.newest_commit.sha)
      end

      def reject_pull_request(serious_violations_count)
        approver.reject(pull_request.repository, pull_request.newest_commit.sha, serious_violations_count)
      end

  end

end
