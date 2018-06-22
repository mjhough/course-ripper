class CourseRipper::Scraper

  @base_url = "https://learn.uq.edu.au" # URL without page
    # @main_page = "availablepcsembed.php" # Page to append to URL
    # @main_url = "#{@base_url}#{@main_page}" # Adds page and URL together
    

    def self.scrape_main_page # Scrapes the main libraries page for primary details
        frontpage = Nokogiri::HTML(open(@base_url))

        binding.pry

        frontpage.css(".chart tr").each do |row|
            name = row.css("a[href]").text

            total_available = row.css(".right").text.split(" ")[0]
            out_of_available = row.css(".right").text.split(" ")[3]

            library_page = row.css("a[href]")[0]["href"]
            library_url = "#{@base_url}#{library_page}"

            libraries << {name: name, total_available: total_available, total_out_of_available: out_of_available, library_url: library_url}
        end
        libraries
    end

    def self.scrape_details_page(library_url) # Scrapes library details page for secondary details
        details_page = Nokogiri::HTML(open(library_url))

        details_page.css("table.chart tr").collect do |level|
            right = level.css(".right").text.split
            {level: level.css(".left").text, available: right[0], out_of_available: right[3]}
        end
    end
end
