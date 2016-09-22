require 'selenium-webdriver'

require_relative './fcms_scraper'

class SeleniumScraper
  def start
    @driver = Selenium::WebDriver.for :remote, url: 'http://localhost:8001'
  end

  def end
    @driver.close
  end

  def get_results(course_code, term)
    @driver.navigate.to 'https://campus.concordia.ca/psc/pscsprd/EMPLOYEE/HRMS/c/CU_EXT.CU_CLASS_SEARCH.GBL'

    select_term(term)
    fill_course(course_code)
    sleep 1
    submit

    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until {
      !@driver.find_elements(:id, 'CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH').empty? ||
      !@driver.find_elements(:class, 'SSSMSGINFOTEXT').empty?
    }
    click_ok unless @driver.find_elements(:class, 'SSSMSGINFOTEXT').empty?

    html = @driver.page_source
    html
  end

  def click_ok
    @driver.find_element(:id, '#ICSave').click
    wait = Selenium::WebDriver::Wait.new(timeout: 30)
    wait.until { @driver.find_element(:class, 'PAPAGETITLE').text.match('Search Results') }
  end

  def submit
    @driver.find_element(:id, 'CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH').click
  end

  def fill_course(course_code)
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_SUBJECT$1').send_keys course_code
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_200$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_300$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_400$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_500$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_600$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_700$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_800$3').click
  end

  def select_term(term_number)
    dropdown = @driver.find_element(:name, 'CLASS_SRCH_WRK2_STRM$35$')
    option = Selenium::WebDriver::Support::Select.new(dropdown)
    option.select_by(:value, term_number)
  end
end