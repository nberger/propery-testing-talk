class ProductsSorter

  def sort(products)
    first_partition = products.partition do |product|
      product.variants.any? {|v| v.stock.to_i >= 100 }
    end

    gte_100 = first_partition[0]
    lt_100 = first_partition[1].partition do |product|
      product.variants.any? {|v| v.stock.to_i != 0 }
    end.flatten

    gte_100.concat(lt_100)
  end

end

class Variant < Struct.new(:stock)
end

class Product < Struct.new(:variants)

  def inspect
    variants.map(&:stock).join("|")
  end

end
