module Linterbot

  class TTYApprover

    def initialize(github_client)
    end

    def approve(repository, sha)
      puts approve_description
    end

    def reject(repository, sha)
      puts reject_description
    end

    def pending(repository, sha)
    end

    def error(repository, sha)
    end

    private

      def approve_description
        "The pull request passed the linter validations!"
      end

      def reject_description
        "There are linter violations that must be fixed!"
      end

  end

end
