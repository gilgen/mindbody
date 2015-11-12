class MindBody::ClassService < MindBody::Service

  def initialize(config)
    super(config, 'ClassService')
  end

  def get_classes

  end

  def get_classes(class_desc_ids: nil, class_ids: nil, staff_ids: nil,
                  start_date_time: nil, end_date_time: nil, client_id: nil,
                  program_ids: nil, session_type_ids: nil, location_ids: nil,
                  semester_ids: nil, hide_canceled_classes: false,
                  scheduling_window: false, fields: [])
    params = {
      # 'ClassIDs': array_of_ints('2264')
      'StartDateTime': start_date_time,
      'EndDateTime': end_date_time,
      # fields: {
      #   'string' => ['Classes.Resource']
      # }
    }

    if fields.any?
      params['XMLDetail'] = 'Bare'
      params[:fields!] = MindBody::Soap.to_array_of_strings(fields)
    end

    result = call!(:get_classes, strip_blanks(params))
    result.body.fetch(:classes, {})[:class]
  end

end
