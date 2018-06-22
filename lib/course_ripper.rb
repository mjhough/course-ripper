# module CourseRipper
# end

require_relative '../config/environment'

include Capybara::DSL

Capybara.default_driver = :selenium

link = "http://learn.uq.edu.au"

visit link
fill_in('username', with: 's4478978')
fill_in('password', with: 'Kooka2024')
click_on('LOGIN')
sleep 5
click_link('Courses')
fill_in('searchText', with: 'MATH1050')
click_on('Go')
current_course = page.all('#listContainer_datatable tr').last
current_course_name = current_course.text
current_course.click_link

File.open("ANNOUNCEMENTS: #{current_course_name}", 'w') do |file|
  page.all('#announcementList li').reverse_each { |ann| file.write("#{ann.text} \n \n") }
end

click_on('Learning Resources')
sleep 5
click_on('Lecture_Recordings')

within_frame 'content' do
  page.all('.menu').each do |lecture|
    lecture.click
    click_link('Download original')
    page.all('.screenOptions a').first(2).each do |video_opt|
      select find(:select).text.split("\n")[1]
      click_on('DOWNLOAD')
    end
  end
end


