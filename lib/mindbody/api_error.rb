class MindBody::ApiError < StandardError
  attr_reader :status, :error_code, :error_message

  def initialize(result)
    @status = result.status
    @error_code = result.error_code
    @error_message = result.error_message
    super("#{result.status} (#{result.error_code}): #{result.error_message}")
  end

end
