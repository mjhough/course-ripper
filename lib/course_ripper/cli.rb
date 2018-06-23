class CourseRipper::CLI
  def call
    c_ripper = CourseRipper::Ripper.new('username', 'password', 'COURSE')
    c_ripper.setup
    c_ripper.rip
    c_ripper.rename
  end
end
