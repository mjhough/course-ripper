class CourseRipper::CLI

    def call
        loading # Shows loading screen while waiting for libraries to be scraped

        create_libraries # Creates library instances for each library hash

        display_libraries # Iterates through all libraries and lists them with an index

        run_gem # Takes the user input and calls methods depending on input
    end

    def loading # Shows loading screen while waiting for libraries to be scraped
        puts "Loading...\n"
    end

    def display_libraries # Gets libraries from array and puts out their names preceded by their index starting at 1.
        system "clear" or system "cls"
        UqLibraries::Library.all.each.with_index(1) do |library, index|
            puts "#{index}. #{library.name}: #{status(index)}"
        end
    end

    def create_libraries # Creates library instances for each library hash
        UqLibraries::Library.create_from_collection(UqLibraries::Scraper.scrape_main_page)
    end

    def status(index) # Helper method for #display_libraries. Shows status of library QUIET/NORMAL/BUSY
        library = UqLibraries::Library.all[index - 1]

        if library.total_available.to_i <= 0.3333333333 * library.total_out_of_available.to_i
            "BUSY".colorize(:red)
        elsif library.total_available.to_i > 0.3333333333 * library.total_out_of_available.to_i && library.total_available.to_i <= 0.666666666666 * library.total_out_of_available.to_i
            "NORMAL".colorize(:yellow)
        elsif library.total_available.to_i > 0.666666666666 * library.total_out_of_available.to_i
            "QUIET".colorize(:green)
        end
    end

    def run_gem # Takes the user input and calls methods depending on input
            puts "\nEnter a number (1-9) to show more information about a library."
            puts "Type `list` to see the library list again or type 'exit' to leave."
            print "> "
            input = gets.strip.downcase

            if input.to_i.between?(1, 12)
                system "clear" or system "cls"
                puts "#{UqLibraries::Library.all[input.to_i - 1].name}"
                puts "---------------------------------------------------".colorize(:blue)
                more_info(input.to_i - 1)
                puts "---------------------------------------------------".colorize(:blue)
                run_gem
            elsif input == "list"
                system "clear" or system "cls"
                display_libraries
                run_gem
            elsif input == "exit"
                system "clear" or system "cls"
                exit
            else
                system "clear" or system "cls"
                puts "\nThat's not a library! Enter the index number of a library (1-9) or type 'list' for a list of libraries.".colorize(:red)
                run_gem
            end
    end

    def more_info(input) # Helper method for #run_gem. Displays more information on the library using the input provided by the user
        details = UqLibraries::Library.all[input].details

        details.each do |level|
            if level[:available].to_i > 0.6666666666 * level[:out_of_available].to_i
                print "QUIET: ".colorize(:green)
                puts "#{level[:level]} has #{level[:available]} computers available out of #{level[:out_of_available]}".gsub("Entry ", "")

            elsif level[:available].to_i > 0.3333333333 * level[:out_of_available].to_i && level[:available].to_i <= 0.666666666666 * level[:out_of_available].to_i
                print "NORMAL: ".colorize(:yellow)
                puts "#{level[:level]} has #{level[:available]} computers available out of #{level[:out_of_available]}".gsub("Entry ", "")

            elsif level[:available].to_i <= 0.3333333333 * level[:out_of_available].to_i
                print "BUSY: ".colorize(:red)
                puts "#{level[:level]} has #{level[:available]} computers available out of #{level[:out_of_available]}".gsub("Entry ", "")
            end
        end
    end
end
