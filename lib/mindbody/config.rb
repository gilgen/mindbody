MindBody::Config = Struct.new(
  :source_name,
  :api_key,
  :username,
  :password,
  :site_id,
  :log,
  :log_level,
  :base_url) do

  def valid?
    # TODO this is completely wrong.
    members.none? do |attr|
      attr.nil?
    end
  end

end
