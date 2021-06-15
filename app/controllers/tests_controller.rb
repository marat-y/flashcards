# frozen_string_literal: true

class TestsController < ApplicationController
  def new
    redirect_to root_path unless FindTestableCard.new(current_user.cards).call.present?
    @test = TestForm.new(user_id: current_user.id).decorate
  end

  def create
    @test = TestForm.new(test_params).call
    if @test.to_be_passed_again_now
      @test.decorate
      flash.now[:alert] = @test.feedback
      render :new
    else
      redirect_to root_path, notice: @test.feedback
    end
  end

  private

  def test_params
    params.require(:test_form).permit(:card_id, :translated_text, :response_time).merge(user_id: current_user.id)
  end
end
