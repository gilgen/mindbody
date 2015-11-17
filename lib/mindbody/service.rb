class MindBody::Service
  attr_reader :client

  def initialize(params, service)
    @config = create_config(params)
    @service = service
    @client = create_client("https://api.mindbodyonline.com/0_5/#{@service}.asmx")
  end

  protected

  def array_of_ints(list)
    MindBody::Soap.to_array_of_ints(list)
  end

  def create_config(params)
    config = MindBody::Config.new(
      params.fetch(:source_name),
      params.fetch(:api_key),
      params.fetch(:username),
      params.fetch(:password),
      params.fetch(:site_id)
    )
    validate(config)
    config
  end

  def do_call(method, params = {})
    response = client.call(method, message: message(params))
    MindBody::Result.new(method, response)
  end

  def do_call!(method, params = {})
    result = do_call(method, params)
    if result.success?
      result
    else
      raise MindBody::ApiError.new(result)
    end
  end

  def strip_blanks(params)
    params.reject { |_, value| value.blank? }
  end

  private

  def create_client(base_url)
    wsdl_url = "#{base_url}?WSDL"
    Savon.client(wsdl: wsdl_url, endpoint: base_url) do |c|
      c.convert_request_keys_to :camelcase
      c.log_level :debug
      c.log true
    end
  end

  def message(params = {})
    {
      'Request' => {
        'SourceCredentials' => source_credentials,
        'UserCredentials' => user_credentials,
      }.merge(params)
    }
  end

  def source_credentials
    {
      'SourceName' => @config.source_name,
      'Password' => @config.api_key,
      'SiteIDs' => {
        'int' => @config.site_id
      }
    }
  end

  def user_credentials
    {
      'Username' => @config.username,
      'Password' => @config.password,
      'SiteIDs' => {
        'int' => @config.site_id
      }
    }
  end

  def validate(config)
    unless config.valid?
      raise "Invalid config: #{config}"
    end
  end

end
