class CourseRipper::Library
    attr_accessor :name, :library_url, :total_available, :total_out_of_available, :details
    @@all = []

    def initialize(library_hash)
        library_hash.each {|attribute, value| self.send("#{attribute}=", value)}
        add_details
        @@all << self
    end

    def self.create_from_collection(libraries_array) # Creates library instance from an array of hashes returned by Scraper#scrape_main_page
        libraries_array.each {|i| self.new(i)}
    end

    def self.all # Getter method for @@all array. Returns all Library instances
        @@all
    end

    def add_details # Sets library.details equal to an array of hashes containing different details for each level of the library
        @details = UqLibraries::LibraryDetails.create_from_collection(UqLibraries::Scraper.scrape_details_page(@library_url))
    end
end
