class MindBody::Payments::StoredCreditCard
  attr_reader :amount, :last_four

  def initialize(amount, last_four)
    @amount = amount
    @last_four = last_four
  end

  def to_h
    raise 'implement me'
    {
    }
  end

end
