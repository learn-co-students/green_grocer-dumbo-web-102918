require 'pry'
def consolidate_cart(cart)
cart_hash = {}
  cart_elements = cart.uniq.each do |element|
     count = cart.count(element)
    #this will count array elements even if hashes
       element.each do |key, value|
         value[:count] = count
         cart_hash[key] = value
        end
   end
cart_hash
end

# #works in base case if coupon is applicable, if coupon applies to 3 items, and only 1 item in cart,
# def apply_coupons(cart, coupons)
# #issue is conversion of hash into integer as the coupon hash is array ,#find a way to save the selected_coupon
# #into its own array with 1 item. Then refer to it as selected_coupon[0]
#   old_count = 0
#   selected_coupon = coupons.select do |element|
#     selected_item = cart.select do |cart_key, cart_value|
#       old_count = cart_value[:count]
#       cart_key == element[:item]
#         if element[:num] <= cart_value[:count]
#            cart_value[:count] = cart_value[:count] - element[:num]
#         end
#      end
#    end
#    if selected_coupon.length != 0
#    food_key = selected_coupon[0][:item] + " W/COUPON"
#    cart[food_key] = {}
#    cart[food_key][:price] = selected_coupon[0][:cost]
#    cart[food_key][:count] = 1
#
#       if old_count <= selected_coupon[0][:num]
#         cart[food_key][:clearance] = true
#       else
#         cart[food_key][:clearance] = false
#       end
#    end
#   cart
# end

#better solution
def apply_coupons(cart, coupons)
  coupons.each do |element|
    name = element[:item]
    if cart[name] && cart[name][:count] >= element[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => element[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= element[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  # code here
  cart_checkout = consolidate_cart(cart)
  cart_coupons = apply_coupons(cart_checkout, coupons)
  cart_clearance = apply_clearance(cart_coupons)
  prices = []

  cart_clearance.each do |key, cart_info|
    total_each_item = cart_info[:price] * cart_info[:count]
    prices << total_each_item
  end

  bill = prices.inject(0) do |total, v|
  total += v
  end

    if bill > 100
     bill = (bill * 0.9).round(2)
     end
  bill
  end
