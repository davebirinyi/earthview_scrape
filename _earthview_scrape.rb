require 'open-uri'
require 'json'
require 'net/http'
require 'addressable/uri'

# Earth View graciously forwards JSON requests to corresponding ID.
# We'll cycle through a range to extract our images and placenames.
# Range begins at 0, allowing 1-for-1 ID matching for exceptions.
@earthview_ary = (0..7200).to_a

# Special Exceptions. These eight links, however, don't auto-forward.
# I believe it has something to do with the non-Latin characters.
# I've manually plugged in working forwarding addresses.
@earthview_ary[1354] = "sanlıurfa-merkez-turkey-1354"
@earthview_ary[1355] = "asagıkaravaiz-turkey-1355"
@earthview_ary[2071] = "عندل-yemen-2071"
@earthview_ary[2090] = "weißwasser-germany-2090"
@earthview_ary[2297] = "vegaøyan-norway-2297"
@earthview_ary[2299] = "herøy-nordland-norway-2299"
@earthview_ary[5597] = "زابل-iran-5597"
@earthview_ary[6058] = "mysove-мисове-crimea-6058"


def scrape_away
  # To save time, we'll skip past gaps I know to be empty.
  # Earth View's numbering starts at 1000 and skips from 2450 to 5000.
  scrape_ary = @earthview_ary.reject { |n| n.to_i.between?(1, 1000) || n.to_i.between?(2450, 5000) }

  # Begin
  scrape_ary.each do |json_id|
    host = "http://earthview.withgoogle.com"
    path = "/_api/#{json_id.to_s}.json"
    uri = Addressable::URI.parse(host + path)
    # The Addressable gem let's us normalize the non-Latin characters.
    # Very important!
    response = Net::HTTP.get_response(URI.parse(host + uri.normalized_path))
    if response.code.to_i < 400   # Filter 404s etc, but allow redirects

      # Collect the necessary information
      data_hash = JSON.parse(open(host + uri.normalized_path).read)
      new_file_name = data_hash["slug"]
      print "#{new_file_name}.jpg... "
      photo_url = data_hash["photoUrl"]
      cleanUrl = photo_url[0..3] + photo_url[5..-1]

      # Create the properly named files
      File.open(new_file_name + '.jpg', 'wb') do |f|
        f.write open(cleanUrl).read
      end
      puts "[✓]"
    else
      puts "--not found--"
    end
  end
  puts ''
  puts "Task complete. Have fun!"
  exit
end

@user_choice = ""
def yesno
  puts "Proceed with the download? (y/n)"
  @user_choice = gets.chomp
  if @user_choice == "y"
    scrape_away
  elsif @user_choice == "n"
    puts "Maybe another time. Bye!"
    exit
  else
    puts "Enter 'y' to download, 'n' to exit."
    yesno
  end
end

@welcome_msg = "Hi. This is a web scraping tool for downloading the "\
              "entire collection of images provided by Google's Earth "\
              "View. As stated on the official website, \"Earth View is "\
              "a collection of the most beautiful and striking landscapes "\
              "found in Google Earth.\" Each image is 1800x1200 and "\
              "spectacular."
@warning_msg = "WARNING: The collection contains more than 1500 images, "\
              "requiring just over a gigabyte of free space. Downloading "\
              "may take a while."
puts ''
puts @welcome_msg
puts ''
puts @warning_msg
puts ''

yesno


