# frozen_string_literal: true

require 'damerau-levenshtein'
class TestForm
  include ActiveModel::Model
  include CardHelper
  include Draper::Decoratable

  attr_accessor :card
  attr_accessor :card_id
  attr_accessor :feedback
  attr_accessor :response_time
  attr_accessor :to_be_passed_again_now
  attr_accessor :translated_text
  attr_accessor :user

  delegate :original_text, to: :card

  def initialize(args = {})
    @user = User.find(args[:user_id])
    @response_time = args[:response_time].to_i
    @card = args[:card_id].present? ? @user.cards.find(args[:card_id]) : FindTestableCard.new(@user.cards).call
    @translated_text = normalize_card_text(args[:translated_text])
  end

  def call
    Test::Process.new(self).call
  end
end
