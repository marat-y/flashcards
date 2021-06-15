class TestFormDecorator < Draper::Decorator
  delegate_all

  def picture
    return unless card.picture

    h.content_tag :div, class: 'row text-center' do
      h.tag :img, src: card.picture.url
    end
  end
end
