# module CourseRipper
# end

require_relative '../config/environment'

include Capybara::DSL

Capybara.register_driver :custom_driver do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = "~/Lectures/MATH1050" # Hard coding
  profile['browser.download.folderList'] = 2
  profile['browser.helperApps.alwaysAsk.force'] = false
  profile['browser.download.manager.showWhenStarting'] = false
  profile['browser.helperApps.neverAsk.saveToDisk'] = "video/mp4"
  profile['csvjs.disabled'] = true
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
end

Capybara.default_driver = :custom_driver

link = "http://learn.uq.edu.au"

visit link
fill_in('username', with: 'USERNAME') # Hard coding
fill_in('password', with: 'NOPE')  # Hard coding
click_on('LOGIN')
sleep 5
click_link('Courses')
fill_in('searchText', with: 'MATH1050') # Hard coding
click_on('Go')
current_course = page.all('#listContainer_datatable tr').last
current_course_name = current_course.text
current_course.click_link

File.open("ANNOUNCEMENTS: #{current_course_name}", 'w') do |file|
  page.all('#announcementList li').reverse_each { |ann| file.write("#{ann.text} \n \n") }
end

click_on('Learning Resources')
sleep 1.5
click_on('Lecture_Recordings')
sleep 3

within_frame 'content' do
  find('.select-typeahead').click
  find('.active-result', text: 'Oldest').click
  page.all('.menu').each do |lecture|
    lecture.click
    click_link('Download original')
    sleep 1.5
    select find(:select).text.split("\n")[1]
    click_on('Download')
  end
end
