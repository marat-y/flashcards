describe "taking a test", type: :feature do
  before :each do
    @card = create :testable_card
  end

  scenario 'Providing correct answer' do
    visit '/tests/new'
    fill_in Card.human_attribute_name(:translated_text), with: @card.translated_text
    click_button I18n.t(:submit)
    expect(page).to have_content I18n.t(:correct)
  end

  scenario 'Providing incorrect answer' do
    visit '/tests/new'
    fill_in Card.human_attribute_name(:translated_text), with: "not #{@card.translated_text}"
    click_button I18n.t(:submit)
    expect(page).to have_content I18n.t(:wrong)
  end
end