require 'pry'
def consolidate_cart(cart)
  result = {}
  cart.each do |item_hash|
    item_hash.each do |item, features|
      if result[item]
        features[:count] += 1 
      else
        features[:count] = 1 
        result[item] = features
      end
    end 
  end
    result
end

def apply_coupons(cart, coupons)
coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, features|
    if features[:clearance]
      new_price = features[:price] * 0.80
      features[:price] = new_price.round(2)
      
    end
  end
    cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end
