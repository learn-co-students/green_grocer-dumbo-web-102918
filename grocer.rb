def consolidate_cart(cart)
  array.uniq.each do |element|
    count = array.count(element)
    #this will count array elements even if hashes
       element.each do |key, value|
        value[:count] = count
       end
  end
end

def apply_coupons(cart, coupons)
  # code here
end

def apply_clearance(cart)
  # code here
end

def checkout(cart, coupons)
  # code here
end
