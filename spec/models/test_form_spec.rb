# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestForm do
  let!(:card) { create(:testable_card, translated_text: 'кошка') }

  context 'when no card_id provided' do
    let(:test) { TestForm.new(user_id: card.user.id) }
    it 'picks a testable card' do
      expect(test.card).to eq(card)
    end
  end
end
