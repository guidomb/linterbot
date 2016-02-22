module Linterbot

  class TTYApprover

    def initialize(github_client)
    end

    def approve(repository, sha)
      puts approve_description
    end

    def reject(repository, sha, serious_violations_count)
      puts reject_description(serious_violations_count)
    end

    def pending(repository, sha)
    end

    def error(repository, sha)
    end

    private

      def approve_description
        "The pull request passed the linter validations!"
      end

      def reject_description(serious_violations_count)
        "There are #{serious_violations_count} serious linter violations that must be fixed!"
      end

  end

end
