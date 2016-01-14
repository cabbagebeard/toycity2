require 'json'
require 'date'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

# Print today's date
def print_date
  puts "Today's Date: #{Time.now.strftime("%m/%d/%Y")}"
end 

def line_break num
  puts "*" * num
  puts " "
end

def report_heading

  puts "  #####                                 ######"    
  puts " #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
  puts " #        #  #  #      #      #         #     # #      #    # #    # #    #   #"
  puts "  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #"
  puts "       # ###### #      #           #    #   #   #      #####  #    # #####    #" 
  puts " #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #" 
  puts "  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #"
  puts "********************************************************************************"

end

def products_heading

  puts "                     _            _       "
  puts "                    | |          | |      "
  puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  puts "| |                                       "
  puts "|_|                                       "

end

def brands_heading

  puts " _                         _     "
  puts "| |                       | |    "
  puts "| |__  _ __ __ _ _ __   __| |___ "
  puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  puts "| |_) | | | (_| | | | | (_| \\__ \\"
  puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  puts

end

# To print from selection of headings
def print_heading heading

  if heading == :sales_report

    report_heading

  elsif heading == :products

    products_heading

  elsif heading == :brand

    brands_heading

  end 
end

def make_products_section 
  # Calculate the total amount of sales and average price sold for
  $products_hash["items"].each do |toy|

  sales_sum = 0
  sales_avg = 0
  num_of_purchases = toy["purchases"].length
  
    toy["purchases"].each do |purchases|
      
      sales_sum += purchases["price"]
      sales_avg = sales_sum / num_of_purchases
    end

  # Calculate the average discount based off the average sales price
  full_price = toy["full-price"].to_i
  avg_discount = ((full_price - sales_avg)/full_price) * 100

    # Print the name of the toy
    puts "Toy Name:  #{toy["title"]}"
    # Print the retail price of the toy
    puts "Toy Price: $#{toy["full-price"]}"
    # Print the total number of purchases
    puts "Total Number of Purchases: #{num_of_purchases}"
    # Print the total amount of sales
    puts "Total Amount Sold: $#{sales_sum}"
    # Print average price the toy sold for
    puts "Average Selling Price: $#{sales_avg}"
    # Print average discount based off average sales price
    puts "Average Discount: #{avg_discount.round(2)}%"

    line_break(25)

  end

end

def make_brands_section
lego = {count: 0, price_sum: 0, sales: 0}
nano_block = {count: 0, price_sum: 0, sales: 0}
$products_hash["items"].each do |toy|
   
  stock = toy["stock"]
  toy_price = toy["full-price"].to_f

   
   if toy["brand"] == "LEGO" 
      brand = lego
      lego[:count] += stock
      lego[:price_sum] += toy_price
      toy["purchases"].each do |purchases|
        lego[:sales] += purchases["price"]
      end
      
   else 
      brand = nano_block
      nano_block[:count] += stock
      nano_block[:price_sum] += toy_price
      toy["purchases"].each do |purchases|
        nano_block[:sales] += purchases["price"]
      end
   end
end
   
   # Print the name of the brand
   puts "Brand: LEGO"
   # Count and print the number of the brand's toys we stock
   puts "Number of Brand's Toys Stocked: #{lego[:count]}"
   
   # Calculate and print the average price of the brand's toys
   puts "Average Price of Brand's Toys: $#{(lego[:price_sum]/2).round(2)}"

   # Calculate and print the total sales volume of all the brand's toys combined

   puts "Total Sales Volume of All Toys Combined: $#{lego[:sales].round(2)}"
   
   # Print the name of the brand
   line_break(25)
   puts "Brand: Nano Block"
   
   # Count and print the number of the brand's toys we stock
   puts "Number of Brand's Toys Stocked: #{nano_block[:count]}"
    
   # Calculate and print the average price of the brand's toys
   puts "Average Price of Brand's Toys: $#{nano_block[:price_sum]}"
    
   # Calculate and print the total sales volume of all the brand's toys combined
   puts "Total Sales Volume of All Toys Combined: $#{nano_block[:sales]}"



end



def create_report

  print_heading :sales_report
  print_date
  print_heading :products
  line_break(42)
  make_products_section
  print_heading :brand
  line_break(42)
  make_brands_section

end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
  $report_file.close
end

start # call start method to trigger report generation 


