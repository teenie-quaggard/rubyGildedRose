# require File.join(File.dirname(__FILE__), '../gilded_rose')
require 'test/unit'
# require 'gilded_rose'

class TestUntitled < Test::Unit::TestCase

  def test_foo
    items = [Item.new("foo", 0, 0)]
    GildedRose.new(items).update_shop()
    assert_equal items[0].name, "foo"
  end

end

