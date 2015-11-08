MindBody::Config = Struct.new(:source_name, :api_key, :username, :password, :site_id) do

  def valid?
    # TODO this is completely wrong.
    members.none? do |attr|
      attr.nil?
    end
  end

end
