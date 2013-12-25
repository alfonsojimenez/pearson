require_relative 'spec_helper'

describe Pearson do
  subject { Pearson }

  describe '.coefficient' do
    context 'when two entities have the same scores' do
      let(:scores) {{
        entity1: {value1: 3.0, value2: 2.0, value3: 1.0},
        entity2: {value1: 3.0, value2: 2.0, value3: 1.0}
      }}

      it 'returns 1' do
        subject.coefficient(scores, :entity1, :entity2).should == 1
      end
    end

    context 'when two entities have inverse scores' do
      let(:scores) {{
        entity1: {value1: 3.0, value2: 2.0, value3: 1.0},
        entity2: {value1: 1.0, value2: 2.0, value3: 3.0}
      }}

      it 'returns -1' do
        subject.coefficient(scores, :entity1, :entity2).should == -1 
      end
    end

    context 'when two entities have no common scores' do
      let(:scores) {{
        entity1: {value1: 0, value2: 0, value3: 0},
        entity2: {value1: 1.0, value2: 2.0, value3: 3.0}
      }}

      it 'returns 0' do
        subject.coefficient(scores, :entity1, :entity2).should == 0 
      end
    end
  end

  describe '.closest_entities' do
    let(:scores) {{
      entity1: {value1: 1.0, value2: 5.0, value3: 2.4},
      entity2: {value1: 3.8, value2: 2.4, value3: 3.0},
      entity3: {value1: 2.1, value2: 2.6, value3: 1.0},
      entity4: {value1: 4.2, value2: 1.0, value3: 2.7},
      entity5: {value1: 2.0, value2: 5.0, value3: 3.8}
    }}

    let(:entity) { :entity1 }

    it 'returns the top matches' do
      subject.closest_entities(scores, entity).first.first.should == :entity5
    end

    context 'when results are limited to 2' do
      it 'returns exactly 2 results' do
        subject.closest_entities(scores, entity, limit: 2).size.should == 2 
      end
    end
  end

  describe '.recommendations' do
    let(:scores) {{
      entity1: {value1: 1.0, value3: 2.4},
      entity2: {value1: 3.8, value2: 2.4, value3: 3.0},
      entity3: {value1: 2.1, value2: 2.6, value3: 1.0},
      entity4: {value1: 4.2, value2: 1.0, value3: 1.0},
      entity5: {value1: 2.0, value2: 5.0, value3: 3.8}
    }}

    let(:entity) { :entity1 }

    it 'returns top recommendations' do
      subject.recommendations(scores, entity).first.first.should == :value2
    end
  end
end

