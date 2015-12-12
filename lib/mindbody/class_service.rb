class MindBody::ClassService < MindBody::Service

  def initialize(config)
    super(config, 'ClassService')
  end

  def get_classes(class_desc_ids: nil, class_ids: nil, staff_ids: nil,
                  start_date_time: nil, end_date_time: nil, client_id: nil,
                  program_ids: nil, session_type_ids: nil, location_ids: nil,
                  semester_ids: nil, hide_canceled_classes: false,
                  scheduling_window: false, fields: [])
    params = {
      'StartDateTime': to_xsd_date_time(start_date_time),
      'EndDateTime': to_xsd_date_time(end_date_time),
      'HideCanceledClasses': hide_canceled_classes,
      'ClientID': client_id,
    }

    if Array(class_ids).any?
      params['ClassIDs'] = MindBody::Soap.to_array_of_ints(class_ids.map(&:to_i))
    end

    if fields.any?
      params['XMLDetail'] = 'Bare'
      params[:fields!] = MindBody::Soap.to_array_of_strings(fields)
    end

    result = do_call!(:get_classes, strip_blanks(params))
    parent = result.body[:classes] || {}
    classes = parent.fetch(:class, [])
    Array.wrap(classes) # single results need to be wrapped.
  end

end
