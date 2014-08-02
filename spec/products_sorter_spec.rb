require 'rspec'

require 'products_sorter'

describe ProductsSorter do

  it "correctly sorts two products with 1 variant each" do
    products = [
      Product.new([Variant.new(4)]),
      Product.new([Variant.new(101)])
    ]

    sorted_products = ProductsSorter.new.sort(products)

    expect(variant_quantities(sorted_products)).to eq [[101], [4]]
  end

  it "correctly sorts three products with 2 variants each" do
    products = [
      Product.new([Variant.new(4), Variant.new(0)]),
      Product.new([Variant.new(0), Variant.new(0)]),
      Product.new([Variant.new(101), Variant.new(nil)])
    ]

    sorted_products = ProductsSorter.new.sort(products)

    expect(variant_quantities(sorted_products)).to eq [[101, nil], [4, 0], [0, 0]]
  end

  it "correctly sorts 5 products with 2 variants each" do
    products = [
      Product.new([Variant.new(4), Variant.new(0)]),
      Product.new([Variant.new(155), Variant.new(18)]),
      Product.new([Variant.new(0), Variant.new(nil)]),
      Product.new([Variant.new(0), Variant.new(0)]),
      Product.new([Variant.new(101), Variant.new(nil)])
    ]

    sorted_products = ProductsSorter.new.sort(products)

    expect(variant_quantities(sorted_products)).to eq [
      [155, 18],
      [101, nil],
      [4, 0],
      [0, nil],
      [0, 0]
    ]
  end

  def variant_quantities(products)
    products.map {|p| p.variants.map(&:stock)}
  end
end
