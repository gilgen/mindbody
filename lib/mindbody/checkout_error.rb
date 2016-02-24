class MindBody::CheckoutError < MindBody::ApiError
  attr_reader :errors

  def initialize(result, checkout_errors)
    super(result)
    @errors = Array.wrap(checkout_errors)
  end

end
