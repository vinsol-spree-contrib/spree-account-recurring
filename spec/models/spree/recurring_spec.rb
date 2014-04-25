require 'spec_helper'

describe Spree::Recurring do
  let(:recurring) { Spree::Recurring::StripeRecurring.create!(name: 'Test recurring', active: true) }

  it { should have_many :plans }
  it { should have_readonly_attribute :type }
  it { should validate_presence_of :type }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:type).with_message('of provider recurring already exists') }

  describe 'preferences' do
    describe 'secret_key' do
      it 'should set secret key in preference' do
        recurring.preferred_secret_key = 'test_secret_key'
      end
    end

    describe 'public_key' do
      it 'should set public key in preference' do
        recurring.preferred_public_key = 'test_public_key'
      end
    end
  end

  describe 'scope active' do
    context 'when active' do
      before(:each) do
        recurring.update_column(:active, true)
      end

      context 'when not deleted' do
        before(:each) do
          recurring.update_column(:deleted_at, nil)
        end
        
        it { Spree::Recurring.active.should eq([recurring]) }
      end

      context 'when deleted' do
        before(:each) do
          recurring.update_column(:deleted_at, Time.current)
        end

        it { Spree::Recurring.active.should eq([]) }
      end
    end

    context 'when active' do
      before(:each) do
        recurring.update_column(:active, false)
      end

      it { Spree::Recurring.active.should eq([]) }
    end
  end

  describe '#self.display_name' do
    it { Spree::Recurring::StripeRecurring.display_name.should eq('StripeRecurring') }
    it { Spree::Recurring.display_name.should eq('Recurring') }
  end

  describe '#visible?' do
    context 'when active' do
      before(:each) do
        recurring.update_column(:active, true)
      end

      context 'when not deleted' do
        before(:each) do
          recurring.update_column(:deleted_at, nil)
        end
        
        it { recurring.should be_visible }
      end

      context 'when deleted' do
        before(:each) do
          recurring.update_column(:deleted_at, Time.current)
        end

        it { recurring.should_not be_visible }
      end
    end

    context 'when active' do
      before(:each) do
        recurring.update_column(:active, false)
      end

      it { recurring.should_not be_visible }
    end
  end

  describe '#default_plan' do
    let(:plan) { recurring.plans.create!(active:true, amount: 10, interval: 'month', interval_count: 1, name: 'Test Plan', currency: 'usd', trial_period_days: 0) }
    before { StripeMock.start }
    after { StripeMock.stop }

    context 'when default plan present' do
      before(:each) do
        plan.update_column(:default, true)
      end

      it { recurring.default_plan.should eq(plan) }
    end

    context 'when default plan not present' do
      before(:each) do
        plan.update_column(:default, false)
      end

      it { recurring.default_plan.should eq(nil) }
    end
  end

  describe '#has_preferred_keys?' do
    context 'when preferred_public_key is set' do
      before(:each) do
        recurring.preferred_public_key = 'preferred_public_key'
      end

      context 'when preferred_secret_key is set' do
        before(:each) do
          recurring.preferred_secret_key = 'preferred_secret_key'
        end

        it { recurring.has_preferred_keys?.should be_true }
      end

      context 'when preferred_secret_key is not set' do
        before(:each) do
          recurring.preferred_secret_key = ''
        end

        it { recurring.has_preferred_keys?.should be_false }
      end
    end

    context 'when preferred_public_key is not set' do
      before(:each) do
        recurring.preferred_public_key = ''
      end

      context 'when preferred_secret_key is set' do
        before(:each) do
          recurring.preferred_secret_key = 'preferred_secret_key'
        end

        it { recurring.has_preferred_keys?.should be_false }
      end

      context 'when preferred_secret_key is not set' do
        before(:each) do
          recurring.preferred_secret_key = ''
        end

        it { recurring.has_preferred_keys?.should be_false }
      end
    end
  end
end