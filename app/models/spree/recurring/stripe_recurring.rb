module Spree
  class Recurring < Spree::Base
    class StripeRecurring < Recurring
      include ApiHandler

      WEBHOOKS = ['customer.subscription.deleted', 'customer.subscription.created', 'customer.subscription.updated', 'invoice.payment_succeeded', 'invoice.payment_failed', 'charge.succeeded', 'charge.failed', 'charge.refunded', 'charge.captured', 'plan.created', 'plan.updated', 'plan.deleted']

      INTERVAL = { week: 'Weekly', month: 'Monthly', year: 'Annually' }
      CURRENCY = { usd: 'USD', gbp: 'GBP', jpy: 'JPY', eur: 'EUR', aud: 'AUD', hkd: 'HKD', sek: 'SEK', nok: 'NOK', dkk: 'DKK', pen: 'PEN', cad: 'CAD'}

      def before_each
        set_api_key
      end
    end
  end
end