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
      StartDateTime: to_xsd_date_time(start_date_time),
      EndDateTime: to_xsd_date_time(end_date_time),
      HideCanceledClasses: hide_canceled_classes,
      ClientID: client_id,
      :'ProgramIDs!' => {"int" => program_ids},
      :'LocationIDs!' => {"int" => location_ids},
    }

    if Array(class_ids).any?
      params['ClassIDs'] = MindBody::Soap.to_array_of_ints(class_ids.map(&:to_i))
    end

    if fields.any?
      params['XMLDetail'] = 'Bare'
      params[:fields!] = MindBody::Soap.to_array_of_strings(fields)
    end

    result = do_call!(:get_classes, strip_blanks(params))
    parse_classes(result)
  end

  def add_clients_to_classes(client_ids, class_ids, require_payment: true,
                             send_email: false, waitlist: false, test: false)

    params = {
      :'ClientIDs!' => {"string" => client_ids},
      :'ClassIDs!' => {"int" => class_ids},
      'RequirePayment' => require_payment,
      'Waitlist' => waitlist,
      'SendEmail' => send_email,
      'Test' => test,
    }

    result = do_call!(:add_clients_to_classes, params)
    parse_classes(result)
  end

  def remove_clients_from_classes(client_ids, class_ids, test: false, send_email: false, late_cancel: false)
    params = {
      'ClientIDs' => to_array_of_strings(client_ids),
      'ClassIDs' => to_array_of_ints(class_ids),
      'Test' => test,
      'SendEmail' => send_email,
      'LateCancel' => late_cancel,
    }

    parent = do_call!(:remove_clients_from_classes, params).body[:classes]
    classes = parent.fetch(:class, [])
    Array.wrap(classes)
  end

  private

  def to_array_of_strings(values)
    MindBody::Soap.to_array_of_strings(values)
  end

  def to_array_of_ints(values)
    ids = Array.wrap(values).map(&:to_i)
    MindBody::Soap.to_array_of_ints(ids)
  end

  def parse_classes(result)
    parent = result.body[:classes] || {}
    classes = parent.fetch(:class, [])
    Array.wrap(classes) # single results need to be wrapped.
  end

end
