require 'selenium-webdriver'

require_relative './fcms_scraper'

class SeleniumScraper
  def start
    @driver = Selenium::WebDriver.for :chrome
  end

  def end
    @driver.close
  end

  def get_results(course_code, course_level)
    @driver.navigate.to 'https://campus.concordia.ca/psc/pscsprd/EMPLOYEE/HRMS/c/CU_EXT.CU_CLASS_SEARCH.GBL'

    select_term('2162')
    fill_course(course_code, course_level)
    sleep 1
    submit

    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until { @driver.find_element(:class, 'PAPAGETITLE').text.match 'Search Results' }
    html = @driver.page_source
    html
  end

  def submit
    @driver.find_element(:id, 'CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH').click
  end

  def fill_course(course_code, course_level)
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_SUBJECT$1').send_keys course_code
    @driver.find_element(:name, "SSR_CLSRCH_WRK_CU_CRSE_LVL_#{course_level}$3").click
  end

  def select_term(term_number)
    dropdown = @driver.find_element(:name, 'CLASS_SRCH_WRK2_STRM$35$')
    option = Selenium::WebDriver::Support::Select.new(dropdown)
    option.select_by(:value, term_number)
  end
end