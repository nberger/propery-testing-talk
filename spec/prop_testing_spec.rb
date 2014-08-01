require 'rspec'
require 'rantly/property'
require 'rantly/rspec_extensions'
require 'products_sorter'

class Variant < Struct.new(:stock)
end

class Product < Struct.new(:variants)

  def inspect
    variants.map(&:stock).join("|")
  end

end

describe "property testing" do

  it "partitions the products in groups with stock >= 100, stock > 0, stock == 0, keeping sort order on each group" do
    property_of {
      len = range(2, 20)
      array(len) {
        freq([1, :literal, nil], [1,:range,0,1], [1,:range,0,100], [1, :positive_integer])
      }
    }.check { |stocks|
      products = build_products(stocks)

      sorted_products = ProductsSorter.new.sort(products)

      # assert keep sort order for products with stock >= 100
      products_gte_100 = products.select { |p| p.variants.any? {|v| v.stock.to_i >= 100} }
      sorted_products_gte_100 = sorted_products.select { |p| p.variants.any? {|v| v.stock.to_i >= 100} }

      expect(sorted_products_gte_100).to eq products_gte_100

      # assert products with stock == 0 go to the end
      products_stock_0 = products.select { |p| p.variants.all? {|v| v.stock.to_i == 0} }
      if products_stock_0.any?
        last_sorted_products = sorted_products[-(products_stock_0.count)..-1]
        expect(last_sorted_products).to eq products_stock_0
      end
    }
  end

  def build_products(stocks)
    stocks.map { |stock|
      Product.new([Variant.new(stock)])
    }
  end

end
