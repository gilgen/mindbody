class MindBody::Purchase
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(item, type, quantity = 1)
    @items << LineItem.new(item, type, quantity)
  end

  def total
    @items.reduce(0) do |memo, line_item|
      memo + line_item.total
    end
  end

  def to_h
    @items.map(&:to_h)
  end

  private

  LineItem = Struct.new(:item, :type, :quantity) do

    def total
      item.price * quantity
    end

    def to_h
      {
        id: item.id,
        type: type,
        quantity: quantity
      }
    end

  end

end
