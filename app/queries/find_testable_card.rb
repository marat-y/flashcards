class FindTestableCard
  attr_accessor :initial_scope
  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call
    scoped = filter_by_deck(initial_scope)
    scoped = filter_by_card(scoped)
    scoped.order(:review_time).first
  end

  private

  def filter_by_card(scope)
    scope.testable
  end

  def filter_by_deck(scope)
    scope.merge(Deck.current)
  end
end
