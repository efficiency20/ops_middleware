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
          elsif revision_from_git == ''
            "unknown"
          else
            revision_from_git
          end
        end
      end

    private

      def revision_from_git
        @revision_from_git ||= `git rev-parse HEAD`.strip
      end

      def revision_file
        @root.join("REVISION")
      end

    end
  end
end
