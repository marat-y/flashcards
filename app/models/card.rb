# frozen_string_literal: true

class Card < ApplicationRecord
  REVIEW_IN_DAYS = 3

  mount_uploader :picture, PictureUploader

  belongs_to :deck
  delegate :user, to: :deck

  validates_with CardSaveValidator
  validates :original_text, :translated_text,
            :review_time, :deck_id,
            presence: true

  scope :testable, -> { where('review_time <= ?', Time.now) }
end
