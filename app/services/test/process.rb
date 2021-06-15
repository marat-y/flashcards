module Test
  class Process
    include CardHelper

    RESPONSE_QUALITY = {
      perfect_response: 5,
      correct_response_after_a_hesitation: 4,
      correct_response_recalled_with_serious_difficulty: 3,
      incorrect_response_with_easy_recall: 2,
      incorrect_response_but_eventually_remembered: 1,
      complete_blackout: 0
    }.freeze

    MAX_PERFECT_RESPONSE_TIME = 10 # seconds
    MIN_SERIOUS_DIFFICULTY_RESPONSE_TIME = 30 # seconds
    HESITATION_PERIOD_IN_SECONDS = ((MAX_PERFECT_RESPONSE_TIME + 1)...MIN_SERIOUS_DIFFICULTY_RESPONSE_TIME).freeze
    ALLOWED_NUMBER_OF_TYPOS = 1

    delegate :card, :response_time, to: :test

    attr_accessor :test

    def initialize(test)
      @test = test
    end

    def call
      add_attempt
      set_response_quality
      process_test_results
      test
    end

    private

    def add_attempt
      card.attempts += 1
      card.save!
    end

    def set_response_quality
      RESPONSE_QUALITY.keys.each do |q|
        card.response_quality = RESPONSE_QUALITY[q] if method("#{q}?").call
      end
      card.save!
    end

    def process_test_results
      if to_be_passed_again_now?
        test.to_be_passed_again_now = true
      else
        test.to_be_passed_again_now = false
        Card::SuperMemoUpdate.new(card).call
      end
      test.feedback = feedback_text
    end

    # Response quality

    def perfect_response?
      successfully_passed? && first_attempt_pass? && response_time <= MAX_PERFECT_RESPONSE_TIME
    end

    def correct_response_after_a_hesitation?
      successfully_passed? && first_attempt_pass? && response_time.in?(HESITATION_PERIOD_IN_SECONDS)
    end

    def correct_response_recalled_with_serious_difficulty?
      successfully_passed? && first_attempt_pass? && response_time >= MIN_SERIOUS_DIFFICULTY_RESPONSE_TIME
    end

    def incorrect_response_with_easy_recall?
      successfully_passed? && !first_attempt_pass? && response_time <= MAX_PERFECT_RESPONSE_TIME
    end

    def incorrect_response_but_eventually_remembered?
      successfully_passed? && !first_attempt_pass? && response_time > MAX_PERFECT_RESPONSE_TIME
    end

    def complete_blackout?
      !successfully_passed? && card.attempts >= SuperMemo2::MAX_ATTEMPTS
    end

    # Test results

    def successfully_passed?
      perfectly_translated? || translated_with_typos?
    end

    def perfectly_translated?
      normalize_card_text(test.translated_text) == normalize_card_text(card.translated_text)
    end

    def translated_with_typos?
      DamerauLevenshtein.distance(normalize_card_text(test.translated_text), normalize_card_text(card.translated_text)) <= ALLOWED_NUMBER_OF_TYPOS
    end

    def first_attempt_pass?
      card.attempts == 1
    end

    def to_be_passed_again_now?
      !successfully_passed? && card.attempts < SuperMemo2::MAX_ATTEMPTS
    end

    # Feedback

    def feedback_text
      if successfully_passed?
        success_feedback
      elsif !successfully_passed? && test.to_be_passed_again_now
        I18n.t('wrong')
      else
        I18n.t('try_again_later', original: card.original_text, translation: card.translated_text)
      end
    end

    def success_feedback
      perfectly_translated? ? I18n.t('test.perfect_translation_feedback') : I18n.t('test.translation_with_typos_feedback', typo: test.translated_text)
    end
  end
end
