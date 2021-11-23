class PeopleController
  attr_reader :params

  def initialize(params)
    @params = params
    @dollar_format = params[:dollar_format] unless params[:dollar_format].empty?
    @percent_format = params[:percent_format] unless params[:percent_format].empty?
  end 

  def normalize
    @heading_dollar_format = file_heading(@dollar_format) unless @params[:dollar_format].empty?
    @heading_percent_format = file_heading(@percent_format) unless @params[:percent_format].empty?
    @dollar_format_list = build_dollar_people_list unless @params[:dollar_format].empty?
    @percent_format_list = build_percent_people_list unless @params[:percent_format].empty?
    @dollar_format_list.concat(@percent_format_list).sort
  end

  private
    def build_dollar_people_list
      response_arr = []
      @dollar_format.each_line.with_index do |line, index|
        next if index == 0
        person_attr = line.split(/[$%]/).collect(&:strip)
        person = People.new(
          person_attr[@heading_dollar_format.index('first_name')], 
          person_attr[@heading_dollar_format.index('city')], 
          person_attr[@heading_dollar_format.index('birthdate')]
        ).parse_text_details

        response_arr << person
      end
      response_arr
    end

    def build_percent_people_list
      response_arr = []
      @percent_format.each_line.with_index  do |line, index|
        next if index == 0
        person_attr = line.split(/[$%]/).collect(&:strip)
        person = People.new(
          person_attr["@heading_#{percent}_format".index('first_name')], 
          person_attr[@heading_percent_format.index('city')], 
          person_attr[@heading_percent_format.index('birthdate')]
        ).parse_text_details

        response_arr << person
      end
      response_arr
    end

    def file_heading text_heading
      text_heading.each_line.first.gsub(/[$%]/, '').split.compact
    end
end
