class MindBody::SaleService < MindBody::Service

  def initialize(config)
    super(config, 'SaleService')
  end

  def checkout_shopping_cart(client_id:, cart_items:, payments:, cart_id:nil,
                             test:false, in_store:false, promo_code:nil,
                             send_email:false, location_id:nil, image:nil,
                             image_file_name:nil)
    params = {
      'LocationID' => location_id,
      'ClientID' => client_id,
      'CartItems' => cart_items_hash(cart_items),
      'Payments' => payments_hash(payments),
      'Test' => test
    }

    body = do_call!(:checkout_shopping_cart, params).body
    cart = body[:shopping_cart] || {}
    wrapper = cart[:cart_items] || {}
    items = wrapper.fetch(:cart_item, [])
    Array.wrap(items) # single results need to be wrapped.
  end

  def get_accepted_card_type
    do_call!(:get_accepted_card_type)
  end

  def get_custom_payment_methods
    do_call!(:get_custom_payment_methods)
  end

  def get_packages(package_ids=nil, sell_online=false)
    # do_call!(:get_packages, package_ids, sell_online)
  end

  def get_products(product_ids=nil, search_text=nil, search_domain=nil,
                   category_ids=nil, sub_category_ids=nil, sell_online=false)
    do_call!(:get_products).body
  end

  def get_sales(sale_id=nil, start_sale_date_time=Date.today,
                end_sale_date_time=Date.today, payment_method_id=nil)
    params = {
      'SaleID' => sale_id
    }
    do_call!(:get_sales, params).body
  end

  def get_services(location_id, program_ids=nil, session_type_ids=nil,
                   service_ids=nil, class_id=nil, class_schedule_id=nil,
                   sell_online=false, hide_related_programs=false, staff_id=nil)
    params = {
      'LocationID' => location_id
    }
    result = do_call!(:get_services, params)
    services = result.body[:services] || {}
    Array.wrap(services[:service])
  end

  def redeem_spa_finder_wellness_card(card_id, face_amount, currency, client_id, location_id=nil)
    # do_call!(:redeem_spa_finder_wellness_card, card_id, face_amount, currency,
      # client_id, location_id)
  end

  def update_products(products, test=false)
    # do_call!(:update_products, products, test)
  end

  def update_services(services, test=false)
      # do_call!(:update_services, services, test)
  end

  private

  def cart_items_hash(items)
    {
      cart_item: items.map do |item|
        cart_item_hash(item)
      end
    }
  end

  def cart_item_hash(item)
    id = item.fetch(:id)
    type = item.fetch(:type)
    quantity = item.fetch(:quantity)

    {
      :quantity => quantity,
      :item => {
        '@xsi:type' => "tns:#{type}",
        'ID' => id
      }
    }
  end

  def payments_hash(payments)
    payments.map do |payment|
      type = payment.delete(:type)
      { :payment_info => payment.merge('@xsi:type' => "tns:#{type}") }
    end
  end

end
