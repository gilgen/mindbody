class MindBody::SaleService < MindBody::Service

  def initialize(config)
    super(config, 'SaleService')
  end

  def checkout_shopping_cart(client_id:, cart_items:, payments:, cart_id:nil,
                             test:false, in_store:false, promo_code:nil,
                             send_email:false, location_id:nil, image:nil,
                             image_file_name:nil)
    params = {
      'ClientID': client_id,
      cart_items: cart_items_hash(cart_items),
      payments: payments_hash(payments),
      test: test
    }

   #  {
   #    :shopping_cart => {
   #     :id => "c74c5d0a-5958-409f-a6e4-a3511b9391e3",
   #     :cart_items => {
   #       :cart_item => {
   #         :item => {
   #           :price => "100.0000",
   #           :online_price => "100.0000",
   #           :tax_rate => "0",
   #           :product_id => "1364",
   #           :id => "1364",
   #           :name => "10 Class Card",
   #           :count => "10",
   #           :"@xsi:type" => "Service"
   #         },
   #         :discount_amount => "0",
   #         :id => "1",
   #         :quantity => "1"
   #       }
   #     },
   #     :sub_total => "100",
   #     :discount_total => "0",
   #     :tax_total => "8",
   #     :grand_total => "108"
   #   }
   # }

    call!(:checkout_shopping_cart, params).body
  end

  def get_accepted_card_type
    call!(:get_accepted_card_type)
  end

  def get_custom_payment_methods
    call!(:get_custom_payment_methods)
  end

  def get_packages(package_ids=nil, sell_online=false)
    # call!(:get_packages, package_ids, sell_online)
  end

  def get_products(product_ids=nil, search_text=nil, search_domain=nil,
                   category_ids=nil, sub_category_ids=nil, sell_online=false)
    call!(:get_products).body
  end

  def get_sales(sale_id=nil, start_sale_date_time=DateTime.today,
                end_sale_date_time=DateTime.today, payment_method_id=nil)
    # call!(:get_sales, sale_id, start_sale_date_time, end_sale_date_time,
      # payment_method_id)
  end

  def get_services(location_id, program_ids=nil, session_type_ids=nil,
                   service_ids=nil, class_id=nil, class_schedule_id=nil,
                   sell_online=false, hide_related_programs=false, staff_id=nil)
    call!(:get_services).body[:services][:service].map do |service|
      [service[:name], service[:id]]
    end
  end

  def redeem_spa_finder_wellness_card(card_id, face_amount, currency, client_id, location_id=nil)
    # call!(:redeem_spa_finder_wellness_card, card_id, face_amount, currency,
      # client_id, location_id)
  end

  def update_products(products, test=false)
    # call!(:update_products, products, test)
  end

  def update_services(services, test=false)
      # call!(:update_services, services, test)
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
      { :payment_info => payment.merge('@xsi:type' => "tns:CreditCardInfo") }
    end
  end

end
