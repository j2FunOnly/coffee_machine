require 'coffee_shop'

RSpec.describe CoffeeShop::Recipe do
  let :recipes do
    {
      'tea with cream' => {
        'tea' => 1,
        'cream' => 1
      }
    }
  end

  before(:each) { subject.prepare('test recipe', recipes['tea with cream']) }

  describe '#initialize' do
    it 'should store ingredients' do
      expect(subject.ingredients).to eq recipes['tea with cream']
    end
  end

  describe '#change' do
    it 'should not change original recipe' do
      subject.change('cream' => 2)
      expect(recipes['tea with cream']).to eq({'tea' => 1, 'cream' => 1})
    end

    describe 'ingredients in recipe list' do
      describe 'increase' do
        it 'should increase by 1 point' do
          subject.change('cream' => 2)
          expect(subject.ingredients).to eq({'tea' => 1, 'cream' => 2})
        end
      end

      describe 'decrease' do
        it 'should decrease by 1 point' do
          subject.change('cream' => -5)
          expect(subject.ingredients).to eq({'tea' => 1, 'cream' => 0})
        end

        it 'should not be less than zero' do
          subject.change('cream' => -1)
          subject.change('cream' => -1)
          expect(subject.ingredients).to eq({'tea' => 1, 'cream' => 0})
        end
      end
    end

    describe 'sugar & lemon' do
      describe 'should allow to add sugar & lemon to recipe list' do
        it 'increase lemon by 1 point' do
          subject.change('lemon' => 5)
          expect(subject.ingredients).to eq recipes['tea with cream'].merge('lemon' => 1)
        end

        it 'increase sugar up to 9 points' do
          subject.change('sugar' => 5)
          expect(subject.ingredients).to eq recipes['tea with cream'].merge('sugar' => 5)
        end
      end
    end

    describe 'ingredients not in recipe list' do
      it 'should ignore increasing ingredients' do
        subject.change('mint' => 1)
        expect(subject.ingredients).to eq(recipes['tea with cream'])
      end
    end
  end
end
