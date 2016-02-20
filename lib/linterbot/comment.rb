require 'forwardable'

module Linterbot

  class Comment
    extend Forwardable

    attr_accessor :sha
    attr_accessor :patch_line_number

    def_delegator :@hint, :reason, :message
    def_delegators :@hint,
      :severity,
      :file

    def initialize(sha:, hint:, patch_line_number:)
      @sha = sha
      @hint = hint
      @patch_line_number = patch_line_number
    end

    private

      attr_accessor :hint

  end

end
