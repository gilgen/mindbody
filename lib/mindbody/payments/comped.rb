class MindBody::Payments::Comped

  def initialize(amount)
    @amount = amount
  end

  def to_h
    {
      type: "CompInfo",
      'Amount' => @amount,
    }
  end

end
