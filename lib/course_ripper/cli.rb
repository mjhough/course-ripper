class CourseRipper::CLI
  def call(argv)
    c_ripper = CourseRipper::Ripper.new(course: argv[1], username: argv[2], password: argv[3])
    c_ripper.set_dir
    if argv[0] == 'rip'
      c_ripper.setup
      c_ripper.rip
    elsif argv[0] == 'rename'
      c_ripper.rename
    end
  end
end
