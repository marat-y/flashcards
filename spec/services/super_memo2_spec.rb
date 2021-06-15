# frozen_string_literal: true

RSpec.describe SuperMemo2 do
  it 'should define integer default e_factor constant' do
    expect(SuperMemo2::DEFAULT_E_FACTOR).to be_a(Numeric)
  end

  it 'should define integer minimal e_factor constant' do
    expect(SuperMemo2::MIN_EASINESS_FACTOR).to be_a(Numeric)
  end

  it 'should define integer minimal acceptable response quality constant' do
    expect(SuperMemo2::MIN_ACCEPTABLE_RESPONSE_QUALITY).to be_a(Numeric)
  end

  it 'should define integer maximum number of attempts constant' do
    expect(SuperMemo2::MAX_ATTEMPTS).to be_a(Numeric)
  end

  it 'should return inter repetition period for given last repetition and e_factor' do
    (0..5).each do |level|
      expect(SuperMemo2.inter_repetition_interval(level, 2.5)).to be_a(ActiveSupport::Duration)
    end
  end

  it 'should return new e_factor for given old e_factor and response_quality' do
    (0..5).each do |response_quality|
      expect(SuperMemo2.new_easiness_factor(2.5, response_quality)).to be_a(Numeric)
    end
  end

  it 'should return new repetitions count for given repetitions_count and response_quality' do
    (0..5).each do |response_quality|
      expect(SuperMemo2.new_repetitions_count(2, response_quality)).to be_a(Numeric)
    end
  end
end
