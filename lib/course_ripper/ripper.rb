class CourseRipper::Ripper
  include Capybara::DSL
  attr_reader :username, :password, :course

  def initialize(username:, password:, course:)
    @username = username
    @password = password
    @course = course
  end

  def set_dir
    dir = "#{Dir.home}/Lectures/#{@course}"
    FileUtils::mkdir_p "#{dir}" unless Dir.exist?(dir)
    Dir.chdir(dir)
  end

  def setup
    Capybara.register_driver :custom_driver do |app|
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.dir'] = "~/Lectures/#{@course}"
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.alwaysAsk.force'] = false
      profile['browser.download.manager.showWhenStarting'] = false
      profile['browser.helperApps.neverAsk.saveToDisk'] = "video/mp4"
      Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
    end
    Capybara.default_driver = :custom_driver
  end

  def rip
    link = "http://learn.uq.edu.au"

    visit link
    fill_in('username', with: @username)
    fill_in('password', with: @password)
    click_on('LOGIN')
    sleep 5
    click_link('Courses')
    fill_in('searchText', with: @course) # Hard coding
    click_on('Go')
    current_course = page.all('#listContainer_datatable tr').last
    current_course.click_link

    File.open("#{@course} Announcements", 'w') do |file|
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

    sleep
  end

  def rename
    Dir.glob('*.mp4') do |filename|
      filename.match(/\W(\d*)\W/) ?
        File.rename(filename, "Lecture #{filename.match(/\W(\d*)\W/)[1]}.mp4")
        : 
          File.rename(filename, "Lecture 0.mp4")
    end
  end
end
