# frozen_string_literal: true

require 'rails_helper'

describe 'taking a test', type: :feature do
  let!(:card) { create :testable_card, translated_text: 'кошка' }
  before do
    login(card.user)
  end

  scenario 'Providing perfectly correct answer' do
    visit '/tests/new'
    fill_in Card.human_attribute_name(:translated_text), with: card.translated_text
    click_button I18n.t(:submit)
    expect(page).to have_content I18n.t('test.perfect_translation_feedback')
  end

  scenario 'Providing correct answer with a typo' do
    visit '/tests/new'
    fill_in Card.human_attribute_name(:translated_text), with: 'кокша'
    click_button I18n.t(:submit)
    expect(page).to have_content I18n.t('test.translation_with_typos_feedback', typo: 'кокша')
  end

  scenario 'Providing incorrect answer' do
    visit '/tests/new'
    fill_in Card.human_attribute_name(:translated_text), with: "not #{card.translated_text}"
    click_button I18n.t(:submit)
    expect(page).to have_content I18n.t(:wrong)
  end

  scenario 'Providing incorrect answer max allowed times' do
    visit '/tests/new'
    SuperMemo2::MAX_ATTEMPTS.times do
      fill_in Card.human_attribute_name(:translated_text), with: "not #{card.translated_text}"
      click_button I18n.t(:submit)
    end
    expect(page).to have_content I18n.t(:try_again_later, original: card.original_text, translation: card.translated_text)
  end
end
