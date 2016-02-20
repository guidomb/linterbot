module Linterbot

  class PullRequest

    class AddedModifiedFiles

      def initialize(files)
        files_key_values = files.select { |file| file.status == "modified" || file.status == "added" }
          .map { |file| [file.filename, file]}
          .flatten
        @files_hash = Hash[*files_key_values]
      end

      def include?(filename)
        files_hash.include?(filename)
      end

      def [](filename)
        files_hash[filename]
      end

      private

        attr_accessor :files_hash

    end

    attr_accessor :github_client
    attr_accessor :repository
    attr_accessor :pull_request_number

    def initialize(repository, pull_request_number, github_client)
      @github_client = github_client
      @repository = repository
      @pull_request_number = pull_request_number
    end

    def added_and_modified_files
      @added_and_modified_files ||= AddedModifiedFiles.new(files)
    end

    def files
      @files ||= fetch_pull_request_files
    end

    def commits
      @commits ||= fetch_pull_request_commits
    end

    def commits_for_file(filename)
      commits.select { |commit| commit.files.map(&:filename).include?(filename) }
    end

    def file_for_filename(filename)
      files.select { |file| file.filename == filename }
        .first
    end

    def patch_for_file(filename)
      file = file_for_filename(filename)
      return file.patch if file
    end

    def newest_commit
      commits.first
    end

    private

      def fetch_pull_request_files
        github_client.pull_request_files(repository, pull_request_number)
          .map { |file| OpenStruct.new(file.to_h) }
      end

      def fetch_pull_request_commits
        github_client.pull_request_commits(repository, pull_request_number)
          .reverse
          .map do |commit|
            full_commit = github_client.commit(repository, commit.sha).to_h
            full_commit[:files].map! { |file| OpenStruct.new(file.to_h) }
            OpenStruct.new(full_commit)
          end
      end

  end

end
