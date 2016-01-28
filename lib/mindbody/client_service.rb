require_relative './service'

class MindBody::ClientService < MindBody::Service

  def initialize(config)
    super(config, 'ClientService')
  end

  def add_arrival(client_id, location_id)
    # do_call!(:add_arrival, client_id, location_id)
  end

  def add_formula_note_to_client_with_appointment(client_id, appointment_id, note)
    # do_call!(:add_client_formula_note, client_id, appointment_id, note)
  end

  def add_formula_note_to_client(client_id, note)
    add_formula_note_to_client_with_appointment(client_id, nil, note)
  end

  def add_or_update_clients(update_action: "Fail", test: false, clients: nil)
    params = {
      update_action: update_action,
      test: test,
      clients: clients
    }

    do_call!(:add_or_update_clients, params).body
  end

  def add_client(client, test: false)
    clients = [{ "Client" => client }]
    add_or_update_clients(update_action: 'AddNew', test: test, clients: clients)
  end

  def add_credit_card_to_client(client_id:, card_number:, card_holder:, city:,
                                address:, state:, postal_code:, exp_month:, exp_year:)
    padded_month = exp_month.to_s.rjust(2, "0")
    params = {
      clients: [
        'Client' => {
          'ID' => client_id,
          'ClientCreditCard' => {
            'CardNumber' => card_number,
            'CardHolder' => card_holder,
            'City' => city,
            'Address' => address,
            'State' => state,
            'PostalCode' => postal_code,
            'ExpMonth' => padded_month,
            'ExpYear' => exp_year,
          }
        }
      ]
    }
    do_call!(:add_or_update_clients, params).body
  end


  def update_contact_log_text(client_id, text)
    # do_call!(:update_contact_log_text, client_id, text)
  end

  def delete_formula_note(client_id, formula_note_id)
    # do_call!(:delete_formula_note, client_id, formula_note_id)
  end

  def get_active_client_memberships(client_id, location_id=nil)
    # do_call!(:get_active_client_memberships, client_id, location_id)
  end

  def get_client_account_balances(client_ids, balance_date=nil, class_id=nil)
    params = {
      'ClientIDs' => MindBody::Soap.to_array_of_strings(client_ids),
    }
    do_call!(:get_client_account_balances, params).body
  end

  def get_current_client_account_balances(client_ids, class_id=nil)
    get_relative_client_account_balances(client_ids, class_id)
  end

  def get_client_contact_logs(client_id,
                         start_date=_time.now,
                         end_date=_time.now,
                         staff_ids=nil,
                         system_generated=false,
                         type_ids=nil,
                         subtype_ids=nil)
    # do_call!(:get_client_contact_logs, client_id, start_date, end_date, staff_ids,
      # system_generated, type_ids, subtype_ids)
  end

  def get_client_contracts(client_id=nil)
    # do_call!(:get_client_contracts, client_id)
  end

  def get_client_formula_notes(client_id, appointment_id=nil)
    # do_call!(:get_client_formula_notes, client_id, appointment_id)
  end

  def get_client_indexes
    do_call!(:get_client_indexes).body
  end

  def get_client_purchases(client_id, start_date:nil, end_date:nil)
    params = {
      'ClientID' => client_id,
      'StartDate' => start_date,
      'EndDate' => end_date,
    }
    result = do_call!(:get_client_purchases, params)
    result.body
  end

  def get_client_referral_types
    do_call!(:get_client_referral_types).body
  end

  def get_clients(ids = nil)
    client_ids = Array(ids)

    params = {
      'Fields' => { 'string' => ['Clients.CustomClientFields'] }
    }

    unless client_ids.empty?
      params.merge!(
        'ClientIDs' => MindBody::Soap.to_array_of_strings(client_ids)
      )
    end

    result = do_call!(:get_clients, params).body
    wrapper = result[:clients] || {}
    Array.wrap wrapper[:client]
  end

  def get_clients_by_string(search_str)
    # do_call!(:get_clients_by_string, search_str)
  end

  def get_client_schedule(client_id, start_date: nil, end_date: nil)
    params = {
      'ClientID' => client_id,
      'StartDate' => start_date,
      'EndDate' => end_date,
    }

    result = do_call!(:get_client_schedule, params).body
    visits = result[:visits] || {}
    Array.wrap visits[:visit]
  end

  def get_client_services(client_id:, class_id: 0, program_ids: nil,
                          session_type_ids: nil, location_ids: nil,
                          visit_count: 0, start_date: nil, end_date: nil,
                          show_active_only: false)
    params = {
      'ClientID' => client_id,
      # 'ClassID' => class_id,
      'ProgramIDs' => MindBody::Soap.to_array_of_ints(program_ids),
      'SessionTypeIDs' => MindBody::Soap.to_array_of_ints(session_type_ids),
      'ShowActiveOnly' => show_active_only,
    }
    result = do_call!(:get_client_services, params)
    wrapper = result.body[:client_services] || {}
    Array.wrap(wrapper[:client_service])
  end

  def get_client_services_for_past_year(client_id, class_id=0, program_ids=nil,
                                   session_type_ids=nil, location_ids=nil, visit_count=0,
                                   show_active_only=false)
    get_client_services(client_id, class_id, program_ids, session_type_ids, location_ids,
      visit_count, _basic_request_helper.one_year_ago, _time.now, show_active_only)
  end

  def get_client_visits(client_id, start_date=_time.now, end_date=_time.now, unpaids_only=false)
    # do_call!(:get_client_visits, client_id, start_date, end_date, unpaids_only)
  end

  def get_contact_log_types
    do_call!(:get_contact_log_types).body
  end

  def get_custom_client_fields
    do_call!(:get_custom_client_fields).body
  end

  def get_required_client_fields
    do_call!(:get_required_client_fields).body
  end

  def send_user_new_password(email, first_name, last_name)
    params = {
      user_email: email,
      user_first_name: first_name,
      user_last_name: last_name
    }
    do_call!(:send_user_new_password, params).success?
  end

  def update_client_services(client_services, test=false)
    # do_call!(:update_client_services, client_services, test)
  end

  def upload_client_document(client_id, file_name, file_size)
    # do_call!(:upload_client_document, client_id, file_name, file_size)
  end

  def validate_login(username, password)
    params = {
      username:  username,
      password:  password
    }
    result = call(:validate_login, params)
    result.success?
  end

end
