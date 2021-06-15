# frozen_string_literal: true

RSpec.describe Test::Process do
  let(:card) { create :card }

  it 'resets card attempts' do
    card.attempts = 2
    expect { Card::SuperMemoUpdate.new(card).call }.to change(card, :attempts).to(0)
  end

  it 'updates review time' do
    expect { Card::SuperMemoUpdate.new(card).call }.to change(card, :review_time)
  end
end
