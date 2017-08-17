module Linterbot

  class Patch

    MODIFIED_FILE_DIFF_REGEXP = /^@@ -\d+,\d+ \+(\d+),(\d+) @@.*$/

    attr_accessor :patch_content

    def initialize(patch_content)
      @patch_content = patch_content || ""
    end

    def chunks_headers
      @chunks_headers ||= parse_chunks_headers
    end

    def additions_ranges
      chunks_headers.map do |diff_header, line_number|
        match = diff_header.match(MODIFIED_FILE_DIFF_REGEXP)
        line_start = match[1].to_i
        line_end = line_start + match[2].to_i
        [line_start...line_end, line_number]
      end
    end

    def additions_ranges_for_hint(hint)
      additions_ranges.select { |diff_range, line_number| diff_range.include?(hint.line) }
    end

    def included_in_patch?(hint)
      additions_ranges_for_hint(hint).count > 0
    end

    private

      def parse_chunks_headers
        patch_content
          .split("\n")
          .each_with_index
          .select { |line, line_number| line.start_with?("@@")  }
      end

  end

end
