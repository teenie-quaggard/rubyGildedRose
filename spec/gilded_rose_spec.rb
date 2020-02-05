# require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'gilded_rose'

describe GildedRose do

  describe "item properties after running #update_shop" do

    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_shop()
      expect(items[0].name).to eq "foo"
    end

    it "an item's SellIn value lowers by one everyday" do
      items = [Item.new("foo", 10, 0)]
      GildedRose.new(items).update_shop()
      expect(items[0].sell_in).to eq(9)
    end

    it "a regular item's quality value decreases by 1 daily" do
      items = [Item.new("foo", 10, 10)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq(9)
    end

    it "quality degrades twice as fast after sell by date" do
      items = [Item.new("foo", -1, 10)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (8)
    end

    it "quality should never be negative" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_shop()
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (0)
    end

    xit "if item is provided a negative quality value, it will return a quality of 0" do
      items = [Item.new("foo", 0, -1)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (0)
    end

    it "Aged Brie increases in quality the older it gets" do
      items = [Item.new("Aged Brie", 20, 10)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (11)
    end

    it "the quality of an item is never more than 50" do
      items = [Item.new("Aged Brie", 50, 50)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (50)
    end

    xit "if an item is provided with a quality value over 50, it will return a quality of 50" do
      items = [Item.new("foo", 50, 55)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (50)
    end

    it "Sulfuras has quality of 80 that never decreases" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
      GildedRose.new(items).update_shop()
      expect(items[0].quality).to eq (80)
      expect(items[0].sell_in).to eq (0)
    end

    it "Backstage passes to a TAFKAL80ETC concert increases in quality as SellIn value approaches but drops to zero after SellIn. 
        5 days or less to SellIn: +3 quality points
        10 days or less to SellIn: +2 quality points
        11+ days to SellIn: +1 quality point
        +1 days after SellIn: 0 quality points" do
      twentyDaysToSellIn = Item.new("Backstage passes to a TAFKAL80ETC concert", 20, 10)
      tenDaysToSellIn = Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 10)
      fiveDaysToSellIn = Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 10)
      afterSellIn = Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 10)
      
      items = [twentyDaysToSellIn, tenDaysToSellIn, fiveDaysToSellIn, afterSellIn]
      GildedRose.new(items).update_shop()
      expect(twentyDaysToSellIn.quality).to eq (11)
      expect(tenDaysToSellIn.quality).to eq (12)
      expect(fiveDaysToSellIn.quality).to eq (13)
      expect(afterSellIn.quality).to eq (0)
    end
  
    it "conjured items degrade in Quality twice as fast as normal items" do
      conjured_item = Item.new("conjured", 50, 50)
      expired_item = Item.new("conjured", -1, 50)
      items = [conjured_item, expired_item]
      GildedRose.new(items).update_shop()
      expect(conjured_item.quality).to eq (48)
      expect(expired_item.quality).to eq (46)
    end

    it "conjured items reduce by 1 in sell_in date when update_shop is run" do
      items = [Item.new("conjured", 50, 50)]
      GildedRose.new(items).update_shop()
      expect(items[0].sell_in).to eq (49)
    end

  end
end
