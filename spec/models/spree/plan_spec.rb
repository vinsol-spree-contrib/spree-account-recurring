require 'spec_helper'

describe Spree::Plan do
  before { StripeMock.start }
  after { StripeMock.stop }

  let(:recurring) { Spree::Recurring::StripeRecurring.create!(name: 'Test recurring', active: true) }
  let(:plan) { recurring.plans.create!(amount: 10, interval: 'month', interval_count: 1, name: 'Test Plan', currency: 'usd', trial_period_days: 0) }

  it { plan.should belong_to :recurring }
  it { plan.should have_many :subscriptions }
  it { plan.should validate_presence_of :amount }
  it { plan.should validate_presence_of :interval }
  it { plan.should validate_presence_of :interval_count }
  it { plan.should validate_presence_of :name }
  it { plan.should validate_presence_of :currency }
  it { plan.should validate_presence_of :recurring_id }
  it { plan.should validate_presence_of :api_plan_id }
  it { plan.should have_readonly_attribute :amount }
  it { plan.should have_readonly_attribute :interval }
  it { plan.should have_readonly_attribute :currency }
  it { plan.should have_readonly_attribute :id }
  it { plan.should have_readonly_attribute :trial_period_days }
  it { plan.should have_readonly_attribute :interval_count }
  it { plan.should have_readonly_attribute :recurring_id }
  it { plan.should have_readonly_attribute :api_plan_id }

  it 'should create stripe plan after creation' do
    Stripe::Plan.all.should be_blank
    plan.reload
    Stripe::Plan.all.should be_present
  end

  it 'should delete stripe plan when soft deleted' do
    plan.reload
    Stripe::Plan.all.should be_present
    plan.update_attributes(deleted_at: Time.current)
    Stripe::Plan.all.should be_blank
  end

  it 'should update stripe plan when plan updated' do
    old_name = Stripe::Plan.retrieve(plan.api_plan_id).name
    plan.update_attributes(name: 'Update test plan')
    Stripe::Plan.retrieve(plan.api_plan_id).name.should_not eq(old_name)
    Stripe::Plan.retrieve(plan.api_plan_id).name.should eq('Update test plan')
  end

  describe 'before_validation manage_default' do
    let(:new_default_plan) { recurring.plans.new(amount: 11, interval: 'month', interval_count: 1, name: 'New Test Plan', currency: 'usd', trial_period_days: 0, default: true) }

    before(:each) do
      plan.update_column(:default, true)
    end

    it 'should remove old default' do
      plan.should be_default
      new_default_plan.save
      plan.reload.should_not be_default
    end

    it 'should set new default' do
      new_default_plan.save
      new_default_plan.should be_default
    end
  end

  describe 'scope active' do
    context 'when active' do
      before(:each) do
        plan.update_column(:active, true)
      end

      context 'when not deleted' do
        before(:each) do
          plan.update_column(:deleted_at, nil)
        end
        
        it { Spree::Plan.active.should eq([plan]) }
      end

      context 'when deleted' do
        before(:each) do
          plan.update_column(:deleted_at, Time.current)
        end

        it { Spree::Plan.active.should eq([]) }
      end
    end

    context 'when active' do
      before(:each) do
        plan.update_column(:active, false)
      end

      it { Spree::Plan.active.should eq([]) }
    end
  end

  describe 'scope visible' do
    context 'when recurring active' do
      before(:each) do
        recurring.update_column(:active, true)
      end

      context 'when recurring not deleted' do
        before(:each) do
          recurring.update_column(:deleted_at, nil)
        end

        context 'when plan active' do
          before(:each) do
            plan.update_column(:active, true)
          end

          context 'when plan is not deleted' do
            before(:each) do
              plan.update_column(:deleted_at, nil)
            end

            it { Spree::Plan.visible.should eq([plan]) }
          end

          context 'when plan is deleted' do
            before(:each) do
              plan.update_column(:deleted_at, Time.current)
            end

            it { Spree::Plan.visible.should eq([]) }
          end
        end

        context 'when plan is not active' do
          before(:each) do
            plan.update_column(:active, false)
          end

          it { Spree::Plan.visible.should eq([]) }
        end
      end

      context 'when recurring is deleted' do
        before(:each) do
          recurring.update_column(:deleted_at, Time.current)
        end

        it { Spree::Plan.visible.should eq([]) }
      end
    end

    context 'when recurring is not active' do
      before(:each) do
        recurring.update_column(:active, false)
      end

      it { Spree::Plan.visible.should eq([]) }
    end
  end

  describe '#visible?' do
    context 'when active' do
      before(:each) do
        plan.active = true
      end

      context 'when not destroyed' do
        before(:each) do
          plan.deleted_at = nil
        end

        context 'when recurring visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(true)
            plan.save
          end

          it { plan.should be_visible }
        end

        context 'when recurring not visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(false)
            plan.save
          end

          it { plan.should_not be_visible }
        end
      end

      context 'when destroyed' do
        before(:each) do
          plan.deleted_at = Time.current
        end

        context 'when recurring visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(true)
            plan.save
          end

          it { plan.should_not be_visible }
        end

        context 'when recurring not visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(false)
            plan.save
          end

          it { plan.should_not be_visible }
        end
      end
    end

    context 'when not active' do
      before(:each) do
        plan.active = false
      end

      context 'when not destroyed' do
        before(:each) do
          plan.deleted_at = nil
        end

        context 'when recurring visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(true)
            plan.save
          end

          it { plan.should_not be_visible }
        end

        context 'when recurring not visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(false)
            plan.save
          end

          it { plan.should_not be_visible }
        end
      end

      context 'when destroyed' do
        before(:each) do
          plan.deleted_at = Time.current
        end

        context 'when recurring visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(true)
            plan.save
          end

          it { plan.should_not be_visible }
        end

        context 'when recurring not visible' do
          before(:each) do
            plan.stub(:recurring).and_return(recurring)
            recurring.stub(:visible?).and_return(false)
            plan.save
          end

          it { plan.should_not be_visible }
        end
      end
    end
  end

  describe '#self.default' do
    context 'when visible' do
      before(:each) do
        plan.update_attributes(active: true, deleted_at: nil)
      end

      context 'when default' do
        before(:each) do
          plan.update_attributes(default: true)
        end

        it { Spree::Plan.default.should eq(plan) }
      end

      context 'when not default' do
        before(:each) do
          plan.update_attributes(default: false)
        end

        it { Spree::Plan.default.should eq(nil) }
      end
    end

    context 'when not visible' do
      before(:each) do
        plan.update_attributes(active: false, deleted_at: nil)
      end

      context 'when default' do
        before(:each) do
          plan.update_attributes(default: true)
        end

        it { Spree::Plan.default.should eq(nil) }
      end

      context 'when not default' do
        before(:each) do
          plan.update_attributes(default: false)
        end

        it { Spree::Plan.default.should eq(nil) }
      end
    end
  end
end