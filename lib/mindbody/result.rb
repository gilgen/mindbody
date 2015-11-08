class MindBody::Result

  def initialize(method, soap_response)
    @method = method
    @soap_response = soap_response
    @response_key= "#{method}_response".to_sym
    @result_key = "#{method}_result".to_sym
  end

  def success?
    error_code == "200"
  end

  def status
    body.fetch(:status)
  end

  def error_code
    body.fetch(:error_code)
  end

  def error_message
    body.fetch(:message)
  end

  def body
    @body ||= @soap_response.body.fetch(@response_key).fetch(@result_key)
  end

end
