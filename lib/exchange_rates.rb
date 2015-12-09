class ExchangeRates
  class << self
    def download
      start
      create_dir
      set_file_name
      File.open(@file_name, 'w') do |file|
        file.puts "Exchange Rates on #{@date}."
        download_page file
      end
      finish
    end

    private

      def start
        puts 'Exchange Rates...'
        puts 'Loading...'
        @date = Date.strptime(DateTime.now.to_s, '%Y-%m-%d')
      end

      def create_dir name = 'Exchange_rates'
        Dir.mkdir(name) unless File.exists?(name)
      end

      def set_file_name
        @file_name = "Exchange_rates/Exchange rates on #{@date}.txt"
      end

      def download_page file
        tbodies = page.css('table.mfcur-table-lg-nbu tbody')
        tbodies.each do |tbody|
          tbody.elements.each do |el|
            currency_code   = el.elements[0].first_element_child['href'].split('/').last
            currency_name   = el.elements[0].text.gsub(/\s+/, ' ').strip
            currency_value  = el.elements[1].css('>text()').text.gsub(/\s+/, ' ').strip +
                              el.elements[1].css('>span:first text()').text.gsub(/\s+/, ' ').strip
            currency_change = el.elements[1].css('>span:last text()').text.gsub(/\s+/, ' ').strip.gsub(/\s+/, '')
            file.puts "#{currency_code} -- #{currency_name} -- #{currency_value} -- #{currency_change}"
          end
        end
      end

      def page
        Nokogiri::HTML(open('http://minfin.com.ua/currency/nbu/'))
      end

      def finish
        puts "Created file: #{@file_name}"
        puts 'Finish...'
      end
  end
end
