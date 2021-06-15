# frozen_string_literal: true

class Card
  class Build
    include CardHelper

    class << self
      def call(options)
        Card.new(defaults.merge(options))
      end

      private

      def defaults
        {
          review_time: Time.now
        }
      end
    end
  end
end
