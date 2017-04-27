require 'mysql2'

##
# Writer used to write Concordia course information to a MySql
# database
##
class SqlWriter
  def initialize(options = {})
    @database = options.fetch(:database, 'ConcordiaCourses')
    @username = options[:username]
    @password = options[:password]
    @host = options.fetch(:host, 'localhost')
    @client = Mysql2::Client.new(
      host: @host,
      username: @username,
      password: @password,
      database: @database
    )
  end

  def close
    @client.close
  end

  def save(courses, semesters, sections)
    clear_tables
    save_courses(courses)
    save_semesters(semesters)
    save_sections(sections)
    @client.close
    puts "Save to database '#{@database}' Completed"
  end

  def clear_tables
    @client.query('DELETE FROM courses')
    @client.query('DELETE FROM sections')
    @client.query('DELETE FROM semesters')
  end

  def save_courses(courses)
    courses.each do |course|
      save_course(course)
      sleep 0.2
    end
  end

  def save_course(course)
    @client.query "
      INSERT INTO courses (uuid, name, code, number)
      VALUES('#{@client.escape(course.id)}', '#{@client.escape(course.name)}', '#{@client.escape(course.code)}', '#{@client.escape(course.number)}')"
    puts "Saved Course #{course.code} #{course.number}"
  end

  def save_semesters(semesters)
    semesters.each do |semester|
      save_semester(semester)
      sleep 0.2
    end
  end

  def save_semester(semester)
    @client.query "
      INSERT INTO semesters (uuid, semester, year)
      VALUES('#{@client.escape(semester.id)}', '#{@client.escape(semester.semester)}', '#{semester.year}')"
    puts "Saved Semester #{semester.semester} #{semester.year}"
  end

  def save_sections(sections)
    sections.each do |section|
      save_section(section)
      sleep 0.2
    end
  end

  def save_section(section)
    @client.query "
      INSERT INTO sections (
        uuid,
        code,
        days,
        time_start,
        time_end,
        room,
        section_type,
        semester_id,
        course_id
      )
      VALUES(
        '#{@client.escape(section.id.to_s)}',
        '#{@client.escape(section.code.to_s)}',
        '#{@client.escape(section.days.to_s)}',
        '#{@client.escape(section.time_start.strftime('%Y-%m-%d %H:%M:%S').to_s)}',
        '#{@client.escape(section.time_end.strftime('%Y-%m-%d %H:%M:%S').to_s)}',
        '#{@client.escape(section.room.to_s)}',
        '#{@client.escape(section.section_type.to_s)}',
        '#{@client.escape(section.semester.to_s)}',
        '#{@client.escape(section.course.to_s)}'
      )"
    puts "Saved Section #{section.code}"
  end
end
