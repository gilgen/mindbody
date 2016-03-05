class MindBody::StaffService < MindBody::Service

  def initialize(config)
    super(config, 'StaffService')
  end

  def get_staff(staff_ids: nil, filters: nil, session_type_id: nil,
                start_date_time: nil, location_id: nil, fields: [])

    params = {
      'StaffIDs' => staff_ids,
      'Filters' => filters,
      'SessionTypeID' => session_type_id,
      'StartDateTime' => start_date_time,
      'LocationID' => location_id,
    }

    if fields.any?
      params['XMLDetail'] = 'Bare'
      params[:'Fields!'] = {"string" => fields}
    end

    result = do_call!(:get_staff, params)
    result.body.fetch(:staff_members, {})[:staff]
  end

  def get_staff_img_url(staff_id)
    do_call!(:get_staff_img_url, staff_id: staff_id).body
  end

end
