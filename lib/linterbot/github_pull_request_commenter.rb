require 'ostruct'

module Linterbot

  class GitHubPullRequestCommenter

    attr_accessor :repository
    attr_accessor :pull_request_number
    attr_accessor :github_client

    def initialize(repository, pull_request_number, github_client)
      @repository = repository
      @pull_request_number = pull_request_number
      @github_client = github_client
    end

    def publish_comment(comment)
      message = "#{comment.severity.upcase} - #{comment.message}\n"
      if comment_exist?(message)
        puts "Comment was not published because it already exists: #{message}"
      else
        create_pull_request_comment(message, comment.sha, comment.file, comment.patch_line_number)
      end
    end

    def publish_summary(summary)
      if same_as_last_summary?(summary)
        puts "Summary was not published because it's the same as the last result summary:\n #{summary}"
      else
        github_client.add_comment(repository, pull_request_number, summary)
      end
    end

    private

      def create_pull_request_comment(message, sha, file, patch_line_number)
        args = [
          repository,
          pull_request_number,
          message,
          sha,
          file,
          patch_line_number
        ]
        github_client.create_pull_request_comment(*args)
      end

      def comment_exist?(message)
        existing_comments.find { |comment| same_comment?(comment, message) }
      end

      def existing_summaries
        @existing_summaries ||= fetch_existing_comments("issue")
      end

      def latest_existing_comment
        @latest_existing_comment ||= existing_summaries.sort { |a, b| b.created_at <=> a.created_at }.first
      end

      def same_as_last_summary?(summary)
        latest_existing_comment && same_comment?(latest_existing_comment, summary)
      end

      def same_comment?(comment, message)
        comment.body == message && comment.user.id == bot_github_id
      end

      def existing_comments
        @existing_comments ||= fetch_existing_comments("pull_request")
      end

      def fetch_existing_comments(source)
        github_client.send("#{source}_comments", repository, pull_request_number).map do |comment|
          user = OpenStruct.new(comment[:user].to_h)
          OpenStruct.new(comment.to_h.merge(user: user))
        end
      end

      def bot_github_id
        @bot_github_id ||= github_client.user[:id]
      end

  end

end
