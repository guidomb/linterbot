require 'octokit'
require 'yaml'
require 'ostruct'
require 'forwardable'

module Linterbot

  class RunnerConfiguration
    extend Forwardable

    class MissingAttribute < Exception

      attr_accessor :attribute_name
      attr_accessor :fix_description

      def initialize(attribute_name, fix_description)
        super("Missing attribute #{attribute_name}")
        @attribute_name = attribute_name
        @fix_description = fix_description
      end

    end

    DEFAULT_PROJECT_BASE_PATH = './'
    DEFAULT_CONFIG_FILE_PATH = './.linterbot.yml'

    attr_accessor :github_client
    attr_accessor :commenter_class
    attr_accessor :approver_class
    attr_accessor :project_base_path
    attr_accessor :linter_report_file

    class << self

      def missing_github_access_token
        fix_description = "You must either define the enviromental variable 'GITHUB_ACCESS_TOKEN " +
          "or the attribute 'github_access_token' in the configuration file.'"
        MissingAttribute.new("GitHub access token", fix_description)
      end

      def load_config_file(config_file_path)
        if File.exist?(config_file_path)
          config = YAML.load(File.read(config_file_path))
          Hash[config.each.map { |key, value| [key.to_sym, value] }]
        else
          {}
        end
      end

      def default_configuration
        {
          project_base_path: File.expand_path(DEFAULT_PROJECT_BASE_PATH),
          linter_report_file: STDIN,
          commenter_class: GitHubPullRequestCommenter,
          approver_class: CommitApprover
        }
      end

      def configuration!(options)
        config_file_path = options.config_file_path || File.expand_path(DEFAULT_CONFIG_FILE_PATH)
        loaded_config = load_config_file(config_file_path)
        base_config = default_configuration.merge(loaded_config)

        github_access_token = ENV["GITHUB_ACCESS_TOKEN"] || base_config[:github_access_token]
        raise missing_github_access_token unless github_access_token
        github_client = Octokit::Client.new(access_token: github_access_token)

        configuration = new(github_client, base_config)
        configuration.project_base_path = options.project_base_path if options.project_base_path
        configuration.linter_report_file = options.linter_report_file_path if options.linter_report_file_path

        if options.dry_run
          configuration.commenter_class = TTYPullRequestCommenter
          configuration.approver_class = TTYApprover
        end

        configuration
      end

    end

    def initialize(github_client, options)
      @github_client = github_client
      @options = options
      @commenter_class = options[:commenter_class]
      @approver_class = options[:approver_class]
      @project_base_path = options[:project_base_path]
      @linter_report_file = options[:linter_report_file]
    end

  end

end
