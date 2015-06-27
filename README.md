# Earth View Scrape

This is a web scraping tool for downloading the entire collection of images provided by Google's Earth View. As stated on the [official website](https://earthview.withgoogle.com), "Earth View is a collection of the most beautiful and striking landscapes found in Google Earth." Each image is 1800x1200 and *spectacular*.

The collection contains more than 1500 images, requiring just over a gigabyte of free space. Downloading will a while.

To run this script: 
- 1. Download the ruby file into the directory where you'll ultimately store the images.
- 2. In your terminal, navigate to where you saved the file.
- 3. Enter `ruby earthview_scrape.rb`
- 4. Answer the prompt.
- 5. Watch the many hundreds of images pour in.

Note: This script has several gem dependencies. If you do not have them installed already, you will need the gems for [JSON](https://rubygems.org/gems/json/) and [Addressable](https://rubygems.org/gems/addressable/)
`gem install json`
`gem install addressable`