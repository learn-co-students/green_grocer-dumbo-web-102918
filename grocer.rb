def consolidate_cart(cart)
  new_cart_hash = {}
  cart.each do |item|
    item.each do |product, value| # value.merge(new key-val)
      if new_cart_hash[product].nil? # if new cart is empty
        new_cart_hash[product] = value.merge({:count => 1}) #start filling
      else
        new_cart_hash[product][:count] += 1 #else add on same products
      end
    end
  end
  new_cart_hash
end

def apply_coupons(cart, coupons)
  new_cart = cart
  coupons.each do |coupon|
    product = coupon[:item] #name of item on coupon
    if !new_cart[product].nil? && new_cart[product][:count] >= coupon[:num]
      #if cart is full and product matches coupon, make a new hash
      with_coupon = {"#{product} W/COUPON" => {
        :price => coupon[:cost],
        :clearance => new_cart[product][:clearance],
        :count => 1
        }
      }
      if new_cart["#{product} W/COUPON"].nil? #if no coupon in cart
        new_cart.merge!(with_coupon) #put it in
      else
        new_cart["#{product} W/COUPON"][:count] += 1 #else increase the count
      end
      new_cart[product][:count] -= coupon[:num] #subtract the product's count from the coupon num
    end
  end
  new_cart
end

def apply_clearance(cart) #discount true clearance items by 20%
  cart.each do |product, cart_value|
    if cart_value[:clearance] == true
      cart_value[:price] = (cart_value[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart) #get cart
  coup_cart = apply_coupons(cons_cart, coupons) #apply coupons to cart
  final_cart = apply_clearance(coup_cart) #apply clearance to coupon's cart
  total = 0 #start total at 0 dollars

  final_cart.each do |product, value|
    total += value[:price] * value[:count] #multiply price by item count and add to the total
  end
  if total > 100 #apply 10% discount if over $100
    total * 0.9
  else
    total
  end
end
