class MindBody::Service
  cattr_accessor :base_url
  PRODUCTION_URL = "https://api.mindbodyonline.com/0_5".freeze

  attr_reader :client

  def initialize(params, service_name)
    @config = create_config(params)
    @client = create_client(service_name)
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
      params.fetch(:site_id),
      params.fetch(:log, false),
      params.fetch(:log_level, :error),
      params.fetch(:base_url, PRODUCTION_URL)
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

  def to_xsd_date_time(datetime)
    return nil if datetime.nil?
    v = if datetime.respond_to? :utc
      datetime.utc
    else
      datetime
    end
    v.strftime("%Y-%m-%dT%H:%M:%SZ") # "yyyy-MM-ddTHH:mm:ssZ"
  end

  private

  def create_client(service_name)
    endpoint_url = "#{@config.base_url}/#{service_name}.asmx"
    wsdl_url = "#{endpoint_url}?WSDL"

    Savon.client(wsdl: wsdl_url, endpoint: endpoint_url) do |c|
      c.convert_request_keys_to :camelcase
      c.log_level @config.log_level
      c.log @config.log
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
