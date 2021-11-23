require 'date'

class People
    attr_accessor :first_name, :city, :birth_date

    def initialize(first_name, city, birth_date)
        @first_name = first_name
        @city = city
        @birth_date = birth_date.to_s
    end

    
    def parse_text_details
        "#{@first_name}, #{@city}, #{Date.parse(@birth_date).strftime('%m/%d/%Y')}"
    end
end