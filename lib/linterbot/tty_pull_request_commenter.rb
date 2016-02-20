module Linterbot

  class TTYPullRequestCommenter

    attr_accessor :repository
    attr_accessor :pull_request_number

    def initialize(repository, pull_request_number, github_client)
      @repository = repository
      @pull_request_number = pull_request_number
    end

    def publish_comment(comment)
      puts "#{repository}##{pull_request_number}"
      puts "#{comment.sha} - #{comment.file}"
      puts "#{comment.severity} - #{comment.message}"
      puts ""
    end

    def publish_summary(summary)
      puts summary
    end

  end

end
