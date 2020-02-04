class GildedRose

  def initialize(items)
    @items = items
  end

  def reduce_sell_in(item)
    item.sell_in -= 1
  end

  def change_quality(item, action, value)
    action == "add" ? item.quality += value : item.quality -= value
  end

  def update_quality()

    @items.each do |item|
      if item.name == "conjured"
        item.sell_in >= 0 ? change_quality(item, "subtract", 2) : change_quality(item, "subtract", 4)
      elsif item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            change_quality(item, "subtract", 1)
          end
        end
      else
        if item.quality < 50 && item.name != "conjured"
          change_quality(item, "add", 1)
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                change_quality(item, "add", 1)
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                change_quality(item, "add", 1)
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        reduce_sell_in(item)
      end
      if item.sell_in < 0 && item.name != "conjured"
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                change_quality(item, "subtract", 1)
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50 && item.name != "conjured"
            increase_quality(item)
          end
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