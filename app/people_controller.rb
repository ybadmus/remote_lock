# frozen_string_literal: true

class PeopleController
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def normalize
    dollar_format = params[:dollar_format]
    heading_dollar_format = file_heading(dollar_format)
    dollar_format_list = build_list(dollar_format, heading_dollar_format)

    percent_format = params[:percent_format]
    heading_percent_format = file_heading(percent_format)
    percent_format_list = build_list(percent_format, heading_percent_format)

    dollar_format_list&.concat(percent_format_list).sort
  end

  private

  def build_list(format, heading_format)
    response_arr = []
    format&.each_line&.with_index do |line, index|
      next if index.zero?

      person_attr = line.split(/[$%]/).collect(&:strip)
      person = People.new(
        person_attr[heading_format&.index('first_name')],
        person_attr[heading_format&.index('city')],
        person_attr[heading_format&.index('birthdate')]
      ).parse_text_details

      response_arr << person
    end
    response_arr
  end

  def file_heading(text_heading)
    return Array.new if text_heading&.empty?
    text_heading&.each_line&.first&.gsub(/[$%]/, '')&.split&.compact
  end
end
