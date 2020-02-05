
class GildedRose

  def initialize(items)
    @items = items
  end

  CONJURED = "conjured"
  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
  SULFURAS = "Sulfuras, Hand of Ragnaros"

  def update_shop
    @items.each do |item|
      update_items(item)
    end
  end

  def reduce_sell_in(item)
    item.sell_in -= 1
  end

  # NEED: change this to a hash to remove argument order dependency?
  def change_quality(item, action, value=0)
    case action
      when "add"
        item.quality += value
      when "subtract"
        item.quality -= value
      when "zero"
        item.quality -= item.quality
      when "max"
        item.quality = 50
      end
  end

  def conjuredItem(item)
    item.sell_in >= 0 ? change_quality(item, "subtract", 2) : change_quality(item, "subtract", 4)
  end

  def backstagePass(item)
    if item.sell_in < 11 && item.quality < 50
        change_quality(item, "add", 1)
    end
    if item.sell_in < 6 && item.quality < 50
        change_quality(item, "add", 1)
    end
      
  end

  def update_items(item)
    if item.name == CONJURED
      conjuredItem(item)
    elsif item.name != AGED_BRIE and item.name != BACKSTAGE_PASS
      if item.quality > 0
        if item.name != SULFURAS
          change_quality(item, "subtract", 1)
        end
      end
    else
      if item.quality < 50 && item.name != CONJURED
        change_quality(item, "add", 1)
        if item.name == BACKSTAGE_PASS
          backstagePass(item)
        end
      end
    end
    if item.name != SULFURAS
      reduce_sell_in(item)
    end
    if item.sell_in < 0 && item.name != CONJURED
      if item.name != AGED_BRIE
        if item.name != BACKSTAGE_PASS
          if item.quality > 0
            if item.name != SULFURAS
              change_quality(item, "subtract", 1)
            end
          end
        else
          change_quality(item, "subtract", item.quality)
        end
      else
        if item.quality < 50 && item.name != CONJURED
          change_quality(item, "add", 1)
        end
      end
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