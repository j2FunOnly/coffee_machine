require 'coffee_shop'

RSpec.describe CoffeeShop::CoffeeMachine do
  describe '#initialize' do
    it 'initialized with empty status' do
      expect(subject.status).to eq({})
    end

    it 'initialized with empty stat' do
      expect(subject.stat).to eq({})
    end
  end

  describe '#load' do
    before(:each) { subject.load }

    it 'load ingredients to max value' do
      expect(subject.status.values).to all(eq described_class::MAX_VOLUME)
    end

    it 'reset stat to empty hash' do
      expect(subject.stat).to eq({})
    end
  end

  describe '#order' do
    before(:each) { subject.load }

    describe 'invalid recipe' do
      it 'should return nil' do
        expect(subject.order('recipe out of list')).to be_nil
      end
    end

    describe 'valid recipe' do
      let(:recipe) { 'tea' }

      before :each do
        subject.load
      end

      it 'should return true' do
        expect(subject.order(recipe)).to be_truthy
      end

      describe 'should change machine states' do
        it 'record order to stat' do
          subject.order(recipe)
          expect(subject.stat).to eq({'tea' => 1})
        end

        it 'change machine status' do
          changes = {'tea' => 1, 'sugar' => -2, 'lemon' => 5, 'cream' => 1}
          subject.order(recipe, changes)
          status = subject.status

          expect(status['tea']).to eq(48)
          expect(status['sugar']).to eq(49)
          expect(status['lemon']).to eq(49)
          expect(status['cream']).to eq(50)
        end
      end

      describe 'not enough ingredients' do
        before :each do
          50.times { subject.order('tea') }
        end

        it 'sugar must be zero' do
          expect(subject.status['sugar']).to be_zero
        end

        it 'should return nil' do
          expect(subject.order('coffee')).to be_nil
        end
      end
    end
  end
end
