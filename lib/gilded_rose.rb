
class GildedRose

  def initialize(items)
    @items = items
  end

  CONJURED = "conjured"
  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"

  MIN_QUALITY = 0
  MAX_QUALITY = 50
  LEGENDARY_QUALITY = 80

  def update_shop
    @items.each do |item|
      update_items(item)
    end
  end

  def update_items(item)
    if item.name == CONJURED
      conjured_item(item)
    elsif item.name == SULFURAS
      sulfuras_item(item)
    elsif item.name == AGED_BRIE
      brie_item(item)
    elsif item.name == BACKSTAGE_PASS
      backstage_pass(item)
    else
      normal_item(item)
    end
  end

  def conjured_item(item)
    reduce_sell_in(item)
    item.sell_in >= 0 ? change_quality(item, "subtract", 2) : change_quality(item, "subtract", 4)
  end

  def sulfuras_item(item)
    change_quality(item, "set", LEGENDARY_QUALITY)
  end

  def brie_item(item)
    item.quality >= 50 ? 
    change_quality(item, "set", MAX_QUALITY) :
    change_quality(item, "add", 1)
  end

  def backstage_pass(item)
    reduce_sell_in(item)
    if item.sell_in < 0
      change_quality(item, "set", MIN_QUALITY)
    elsif item.sell_in <= 5
      change_quality(item, "add", 3)
    elsif item.sell_in <= 10
      change_quality(item, "add", 2)
    elsif item.sell_in > 10
      change_quality(item, "add", 1)
    else
      item
    end 
  end

  def normal_item(item)
    reduce_sell_in(item)
    if item.sell_in <= 1 and item.quality > 2
      change_quality(item, "subtract", 2)
    elsif item.quality.between?(1, 50)
      change_quality(item, "subtract", 1)
    end
  end

  def reduce_sell_in(item)
    item.sell_in -= 1
  end

  def check_max_quality(item)
    if item.name == SULFURAS
      item.quality = LEGENDARY_QUALITY
    else
      item.quality > MAX_QUALITY ? item.quality = MAX_QUALITY : item.quality
    end
  end

  # NEED: change this to decouple dependencies
  def change_quality(item, action, value=0)
    check_max_quality(item)
    case action
      when "add"
        item.quality += value
      when "subtract"
        item.quality -= value
      when "set"
        item.quality = value
      else
        item
    end
  end

end
  

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end