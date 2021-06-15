# frozen_string_literal: true

# SuperMemo2 system variables
class SuperMemo2
  DEFAULT_E_FACTOR = 2.5
  MIN_EASINESS_FACTOR = 1.3
  MIN_ACCEPTABLE_RESPONSE_QUALITY = 3
  MAX_ATTEMPTS = 2

  class << self
    def inter_repetition_interval(last_repetition_number, easiness_factor)
      return if last_repetition_number.negative?

      case last_repetition_number
      when 0
        0.seconds
      when 1
        1.day
      when 2
        6.days
      else
        (inter_repetition_interval(last_repetition_number - 1, easiness_factor) * easiness_factor).days
      end
    end

    def new_easiness_factor(old_easiness_factor, responce_quality)
      new_ef = old_easiness_factor + (0.1 - (5 - responce_quality) * (0.08 + (5 - responce_quality) * 0.02))
      new_ef = MIN_EASINESS_FACTOR if new_ef < MIN_EASINESS_FACTOR
      new_ef
    end

    def new_repetitions_count(repetitions_count, response_quality)
      response_quality < MIN_ACCEPTABLE_RESPONSE_QUALITY ? 0 : repetitions_count + 1
    end
  end
end
