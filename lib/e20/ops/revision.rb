require "active_support"

module E20
  module Ops
    class Revision

      def initialize(root = Pathname.new(Dir.pwd))
        @root = root
      end

      def to_s
        @revision ||= begin
          if revision_file.exist?
            revision_file.read.strip
          elsif revision_from_git.present?
            revision_from_git
          else
            "unknown"
          end
        end
      end

    private

      def revision_from_git
        @revision_from_git ||= `git rev-parse HEAD 2>/dev/null`.strip
      end

      def revision_file
        @root.join("REVISION")
      end

    end
  end
end
