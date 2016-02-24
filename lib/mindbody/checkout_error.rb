class MindBody::CheckoutError < MindBody::ApiError

  def initialize(result, checkout_errors)
    super(result)
    @errors = Array.wrap(checkout_errors)
  end

  def error_message
    if @errors.any?
      @errors.map do |error|
        error[:string].gsub(/Item \d+ -/, '')
      end.join(" ")
    else
      @error_message
    end
  end

end
