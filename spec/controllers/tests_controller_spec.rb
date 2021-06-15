# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController, type: :controller do
  describe 'GET #new' do
    context 'with no flashcards to test' do
      let!(:user) { create :user }
      it 'redirects to root' do
        login_user(user)
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
    context 'with flashcards to test' do
      let!(:card) { create(:card, review_time: Time.now) }
      before do
        login_user(card.user)
        get :new
      end
      it 'assigns @test' do
        expect(assigns(:test)).to be_a(TestForm)
      end
      it 'renders new' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    let!(:card) { create(:testable_card) }
    before do
      login_user(card.user)
    end

    context 'with successful test' do
      let(:correct_attrs) { { card_id: card.id, translated_text: card.translated_text } }

      it 'moves the card review time' do
        expect do
          post :create, params: { test_form: correct_attrs }
          card.reload
        end.to change(card, :review_time)
      end

      it 'redirects to root' do
        post :create, params: { test_form: correct_attrs }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with failed test' do
      let(:incorrect_attrs) { { card_id: card.id, translated_text: 'incorrect text' } }

      it 'doesnt change card' do
        post :create, params: { test_form: incorrect_attrs }
        expect(card.review_time.to_i).to eq(card.reload.review_time.to_i)
      end

      it 'renders new' do
        post :create, params: { test_form: incorrect_attrs }
        expect(response).to render_template(:new)
      end
    end
  end
end
