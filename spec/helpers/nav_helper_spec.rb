require 'rails_helper'

RSpec.describe NavHelper, type: :helper do
  describe 'active link_to' do
    before(:each) do
      allow(helper).to receive(:controller_name).and_return('cards')
    end
    it 'adds active class to links' do
      expect(helper.active_link_to("anchor", cards_path, controller_name: 'cards')).to eq(link_to 'anchor', cards_path, class: 'active' )
    end
  end
end
