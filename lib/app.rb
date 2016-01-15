require 'json'

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def line_break num
  $report_file.puts "*" * num
  $report_file.puts " "
end

def report_heading

  $report_file.puts "  #####                                 ######"    
  $report_file.puts " #     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
  $report_file.puts " #        #  #  #      #      #         #     # #      #    # #    # #    #   #"
  $report_file.puts "  #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #"
  $report_file.puts "       # ###### #      #           #    #   #   #      #####  #    # #####    #" 
  $report_file.puts " #     # #    # #      #      #    #    #    #  #      #      #    # #   #    #" 
  $report_file.puts "  #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #"
  $report_file.puts "********************************************************************************"

  # Print today's date
  $report_file.puts "Today's Date: #{Time.now.strftime("%m/%d/%Y")}"
  require 'date'

end

def products_heading

  $report_file.puts "                     _            _       "
  $report_file.puts "                    | |          | |      "
  $report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  $report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  $report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  $report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  $report_file.puts "| |                                       "
  $report_file.puts "|_|                                       "

end

def brands_heading

  $report_file.puts " _                         _     "
  $report_file.puts "| |                       | |    "
  $report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
  $report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  $report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
  $report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  $report_file.puts

end

# To print from selection of headings
def print_heading(heading)

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
  full_price = toy["full-price"].to_f
  avg_discount = ((full_price - sales_avg)/full_price) * 100

    # Print the name of the toy
    $report_file.puts "Toy Name:  #{toy["title"]}"
    # Print the retail price of the toy
    $report_file.puts "Toy Price: $#{toy["full-price"]}"
    # Print the total number of purchases
    $report_file.puts "Total Number of Purchases: #{num_of_purchases}"
    # Print the total amount of sales
    $report_file.puts "Total Amount Sold: $#{sales_sum}"
    # Print average price the toy sold for
    $report_file.puts "Average Selling Price: $#{sales_avg}"
    # Print average discount based off average sales price
    $report_file.puts "Average Discount: #{avg_discount.round(2)}%"

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
   $report_file.puts "Brand: LEGO"
   # Count and print the number of the brand's toys we stock
   $report_file.puts "Number of Brand's Toys Stocked: #{lego[:count]}"
   
   # Calculate and print the average price of the brand's toys
   $report_file.puts "Average Price of Brand's Toys: $#{(lego[:price_sum]/2).round(2)}"

   # Calculate and print the total sales volume of all the brand's toys combined
   $report_file.puts "Total Sales Volume of All Toys Combined: $#{lego[:sales].round(2)}"
   
   # Print the name of the brand
   line_break(25)
   $report_file.puts "Brand: Nano Block"
   
   # Count and print the number of the brand's toys we stock
   $report_file.puts "Number of Brand's Toys Stocked: #{nano_block[:count]}"
    
   # Calculate and print the average price of the brand's toys
   $report_file.puts "Average Price of Brand's Toys: $#{nano_block[:price_sum]}"
    
   # Calculate and print the total sales volume of all the brand's toys combined
   $report_file.puts "Total Sales Volume of All Toys Combined: $#{nano_block[:sales]}"
   line_break(25)


end


def create_report
  print_heading(:report)
  print_heading(:products)
  line_break(42)
  make_products_section
  print_heading(:brand)
  line_break(42)
  make_brands_section
end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation 


