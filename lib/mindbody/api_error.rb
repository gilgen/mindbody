class MindBody::ApiError < StandardError

  def initialize(result)
    super("#{result.status} (#{result.error_code}): #{result.error_message}")
  end

end
