module E20
  module Ops
    class Hostname

      def to_s
        @hostname ||= `hostname`.strip
      end

    end
  end
end
