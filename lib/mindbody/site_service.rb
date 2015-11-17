class MindBody::SiteService < MindBody::Service

  def initialize(config)
    super(config, 'SiteService')
  end

  def get_resource_schedule
    # <Date>dateTime</Date>
    do_call!(:get_resource_schedule)
  end

  def get_resources(session_type_ids: nil, location_id: 0,
                    start_date_time: nil, end_date_time: nil)
    # <SessionTypeIDs>
    #   <int>int</int>
    #   <int>int</int>
    # </SessionTypeIDs>
    # <LocationID>int</LocationID>
    # <StartDateTime>dateTime</StartDateTime>
    # <EndDateTime>dateTime</EndDateTime>
    params = {
      'SessionTypeIDs': MindBody::Soap.to_array_of_ints(session_type_ids),
      location_id: location_id,
      # start_date_time: start_date_time,
      # end_date_time: end_date_time
    }
    result = do_call!(:get_resources, params)
    result.body[:resources][:resource]
  end

  def reserve_resource(resource_id, client_id)
    # <ResourceID>int</ResourceID>
    # <ClientID>int</ClientID>
    # <StaffID>int</StaffID>
    # <StartDateTime>dateTime</StartDateTime>
    # <EndDateTime>dateTime</EndDateTime>
    # <LocationID>int</LocationID>
    # <ProgramID>int</ProgramID>
    # <Notes>string</Notes>

    args = {
      resource_id: resource_id,
      client_id: client_id,
    }

    do_call!(:reserve_resource, args).body
  end

  def get_activation_code
    do_call!(:get_activation_code).body
  end

  def get_locations
    do_call!(:get_locations).body.fetch(:locations, {}).fetch(:location)
  end

  def get_programs(schedule_type="All", online_only=false)
    do_call!(:get_programs).body
  end

  def get_relationships
    do_call!(:get_relationships).body
  end

  def get_session_types(program_ids=nil, online_only=false)
    params = {
      'ProgramIDs': MindBody::Soap.to_array_of_ints(program_ids),
      online_only: online_only
    }

    types = do_call!(:get_session_types, params).body[:session_types][:session_type]
    types.map do |attrs|
      id = attrs.fetch(:id)
      name = attrs.fetch(:name)
      length = attrs.fetch(:default_time_length)
      MindBody::SessionType.new(id, name, length)
    end
  end

  def get_sites(search_text=nil, related_site_id=nil)
    do_call!(:get_sites).body
  end

end
