require_relative './lib/course_ripper/version'

Gem::Specification.new do |s|
    s.name        = 'course-ripper'
    s.version     = CourseRipper::VERSION
    s.date        = '2018-06-01'
    s.summary     = "Rip UQ course files"
    s.description = "Shows users how busy a selected UQ library is."
    s.authors     = ["Matt Hough"]
    s.email       = "matt@hough.tv"
    s.files       = ["lib/course_ripper.rb", "lib/course_ripper/cli.rb", "lib/course_ripper/scraper.rb", "lib/course_ripper/library.rb", "lib/course_ripper/library_details.rb", "config/environment.rb"]
    s.homepage    = 'http://rubygems.org/gems/uq-libraries'
    s.license     = 'MIT'
    s.executables << 'course-ripper'

    s.add_runtime_dependency "colorize"
    s.add_runtime_dependency "capybara"
    s.add_runtime_dependency "selenium-webdriver"

    s.add_development_dependency "bundler"
    s.add_development_dependency "rake"
    s.add_development_dependency "rspec"
    s.add_development_dependency "nokogiri"
    
    s.add_dependency "pry"
end
