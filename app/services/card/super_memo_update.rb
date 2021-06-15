# updates card according to Leitner methodology
# frozen_string_literal: true

class Card
  class SuperMemoUpdate
    attr_accessor :card

    def initialize(card)
      @card = card
    end

    def call
      reset_attempts
      set_e_factor
      set_repetitions_count
      set_next_review_time
      @card.save!
    end

    private

    def reset_attempts
      @card.attempts = 0
    end

    def set_e_factor
      @card.e_factor = SuperMemo2.new_easiness_factor(@card.e_factor, @card.response_quality)
    end

    def set_repetitions_count
      @card.repetitions_count = SuperMemo2.new_repetitions_count(@card.repetitions_count, @card.response_quality)
    end

    def set_next_review_time
      @card.review_time = Time.now + SuperMemo2.inter_repetition_interval(@card.repetitions_count, @card.e_factor)
    end
  end
end
