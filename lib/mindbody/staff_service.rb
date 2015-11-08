class MindBody::StaffService < MindBody::Service

  def initialize(config)
    super(config, 'StaffService')
  end

  def get_staff(staff_ids=nil, staff_username=nil, staff_password=nil,
                site_ids=nil, filters=nil, session_type_id=nil,
                start_date_time=nil, location_id=nil)
    params = {
      staff_username: staff_username,
      staff_password: staff_password,
      site_ids: site_ids,
      filters: filters,
      session_type_id: session_type_id,
      start_date_time: start_date_time,
      location_id: location_id,
    }

    call!(:get_staff, params).body[:staff_members][:staff]
  end

  def get_staff_img_url(staff_id)
    call!(:get_staff_img_url, staff_id: staff_id).body
  end

end
