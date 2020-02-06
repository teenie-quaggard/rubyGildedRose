CONJURED = "conjured"
AGED_BRIE = "Aged Brie"
BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
SULFURAS = "Sulfuras, Hand of Ragnaros"

MIN_QUALITY = 0
MAX_QUALITY = 50
LEGENDARY_QUALITY = 80

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_shop
    @items.each do |item|
      HelperMethods.reduce_sell_in(item)
      update_items(item)
    end
  end

  def update_items(item)
    if item.name == CONJURED
      item.update_conjured(item)
    elsif item.name == SULFURAS
      sulfuras_item(item)
    elsif item.name == AGED_BRIE
      brie_item(item)
    elsif item.name == BACKSTAGE_PASS
      backstage_pass(item)
    else
      item.update_quality()
    end
  end

  # def conjured_item(item)
  #   item.sell_in >= 0 ? HelperMethods.change_quality(item, "subtract", 2) : HelperMethods.change_quality(item, "subtract", 4)
  # end

  def sulfuras_item(item)
    HelperMethods.change_quality(item, "set", LEGENDARY_QUALITY)
    HelperMethods.set_sell_in(item, 0)
  end

  def brie_item(item)
    item.quality >= MAX_QUALITY ? 
    HelperMethods.change_quality(item, "set", MAX_QUALITY) :
    HelperMethods.change_quality(item, "add", 1)
  end

  def backstage_pass(item)
    if item.sell_in < 0
      HelperMethods.change_quality(item, "set", MIN_QUALITY)
    elsif item.sell_in <= 5
      HelperMethods.change_quality(item, "add", 3)
    elsif item.sell_in <= 10
      HelperMethods.change_quality(item, "add", 2)
    elsif item.sell_in > 10
      HelperMethods.change_quality(item, "add", 1)
    else
      item
    end 
  end

end


module HelperMethods
  def self.reduce_sell_in(item)
    item.sell_in -= 1
  end

  def self.check_max_quality(item)
    if item.name == SULFURAS
      item.quality = LEGENDARY_QUALITY
    else
      item.quality > MAX_QUALITY ? item.quality = MAX_QUALITY : item.quality
    end
  end

  def self.change_quality(item, action, value=0)
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

  def self.set_sell_in(item, value)
    item.sell_in = value
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

class ConjuredItem < Item
  def initialize(name, sell_in, quality)
    super(name, sell_in, quality)
  end

  def update_conjured(item)
    item.sell_in >= 0 ? HelperMethods.change_quality(item, "subtract", 2) : HelperMethods.change_quality(item, "subtract", 4)
  end
end

class NormalItem < Item
  def initialize(name, sell_in, quality)
    super(name, sell_in, quality)
  end

  def update_quality
    if self.sell_in < 0 and self.quality > 2
      HelperMethods.change_quality(self, "subtract", 2)
    elsif self.quality.between?(MIN_QUALITY + 1, MAX_QUALITY)
      HelperMethods.change_quality(self, "subtract", 1)
    end
  end
end
