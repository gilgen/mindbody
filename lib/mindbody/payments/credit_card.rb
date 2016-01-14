class MindBody::Payments::CreditCard

  def initialize(amount, credit_card_number, billing_address, billing_city,
                 billing_state, billing_postal_code, billing_name, exp_month,
                 exp_year)
    @amount = amount
    @credit_card_number = credit_card_number
    @billing_address = billing_address
    @billing_city = billing_city,
    @billing_state = billing_state
    @billing_postal_code = billing_postal_code
    @billing_name = billing_name
    @exp_month = exp_month
    @exp_year = exp_year
  end

  def to_h
    {
      type: 'CreditCardInfo',
      credit_card_number: credit_card_number,
      amount: @amount,
      billing_address: @billing_address,
      billing_city: @billing_city,
      billing_state: @billing_state,
      billing_postal_code: @billing_postal_code,
      billing_name: @billing_name,
      exp_month: @exp_month,
      exp_year: @exp_year,
    }
  end

  def credit_card_number
    @credit_card_number.gsub(/\D/, '')
  end

end
