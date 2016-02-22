module Linterbot

  class CommitApprover

    attr_accessor :github_client

    def initialize(github_client)
      @github_client = github_client
    end

    def approve(repository, sha)
      github_client.create_status(repository, sha, "success", context: context, description: approve_description)
    end

    def reject(repository, sha, serious_violations_count)
      github_client.create_status(repository, sha, "failure", context: context, description: reject_description(serious_violations_count))
    end

    def pending(repository, sha)
      github_client.create_status(repository, sha, "pending", context: context)
    end

    def error(repository, sha)
      github_client.create_status(repository, sha, "error", context: context)
    end

    private

      def context
        "linterbot"
      end

      def approve_description
        "The pull request passed the linter validations!"
      end

      def reject_description(serious_violations_count)
        "There are #{serious_violations_count} serious linter violations that must be fixed!"
      end

  end

end
