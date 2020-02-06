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
      reduce_sell_in(item)
      update_items(item)
    end
  end

  def reduce_sell_in(item)
    item.sell_in -= 1
  end

  def update_items(item)
    case item.name
    when CONJURED
      item.update_conjured(item)
    when SULFURAS
      item.update_sulfuras(item)
    when AGED_BRIE
      item.update_brie(item)
    when BACKSTAGE_PASS
      item.update_backstage_pass(item)
    else
      item.update_normal(item)
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

class ConjuredItem < Item
  def update_conjured(item)
    item.sell_in >= 0 ? HelperMethods.change_quality(item, "subtract", 2) : HelperMethods.change_quality(item, "subtract", 4)
  end
end

class NormalItem < Item
  def update_normal(item)
    if item.sell_in < 0 and self.quality > 2
      HelperMethods.change_quality(self, "subtract", 2)
    elsif item.quality.between?(MIN_QUALITY + 1, MAX_QUALITY)
      HelperMethods.change_quality(self, "subtract", 1)
    end
  end
end

class SulfurasItem < Item
  def update_sulfuras(item)
    HelperMethods.change_quality(item, "set", LEGENDARY_QUALITY)
    HelperMethods.set_sell_in(item, 0)
  end
end

class BrieItem < Item
 def update_brie(item)
    item.quality >= MAX_QUALITY ? 
    HelperMethods.change_quality(item, "set", MAX_QUALITY) :
    HelperMethods.change_quality(item, "add", 1)
  end
end

class BackstagePassItem < Item
  def update_backstage_pass(item)
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
    sell_in = item.sell_in 
  end
end

module HelperMethods
  def self.check_max_quality(item)
    item.quality > MAX_QUALITY ? item.quality = MAX_QUALITY : item.quality
  end

  def self.change_quality(item, action, value=0)
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