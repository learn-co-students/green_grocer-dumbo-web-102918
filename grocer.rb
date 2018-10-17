require "pry"

def consolidate_cart(cart)
  consolidate = Hash.new(0)
  cart.each do |hash|
    hash.each do |key, value|
      consolidate[key] = value.merge({:count =>cart.count(hash)})
    end
  end
 consolidate
end

def apply_coupons(cart, coupons)
  result = Hash.new

  count = 0
    cart.each do |key, hash|
      coupons.each do |hash2|
        if hash2[:item] == key && cart[key][:count] >= hash2[:num]
         count += 1
         result[key + " W/COUPON" ] = {:price => hash2[:cost], :clearance => cart[key][:clearance], :count=> count}
         cart[key][:count] -= hash2[:num]
        end
      end
      count = 0
    end
  cart.merge(result)
end

def apply_clearance(cart)
  keys = cart.keys

   keys.each do |string|
      if cart[string][:clearance]
        discount = cart[string][:price]*0.20
        cart[string][:price]-= discount
      end
   end
   cart
end

def checkout(cart, coupons)
  cart_consolidate = consolidate_cart(cart)
  cart_coupons = apply_coupons(cart_consolidate, coupons)
  result = apply_clearance(cart_coupons)
  keys = result.keys
  total = 0.0
  keys.each do |string|
    if result[string][:count] > 0
      total += result[string][:price] * result[string][:count]
    end

  end

  if total > 100
    discount = total * 0.10
    total -= discount
  end
  total
end
