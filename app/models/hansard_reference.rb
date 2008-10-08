class HansardReference

  attr_reader :house, :date, :volume, :column, :end_column, :series

  MONTHS = Date::MONTHNAMES[1..12]
  SHORT_MONTHS = Date::ABBR_MONTHNAMES[1..12]

  REFERENCE_PATTERN = /H(C|L) Deb\s+.+$/i

  DATE_PATTERN = /(?:\s|\A)(\d\d?)\s+(#{MONTHS.join('|')}|#{SHORT_MONTHS.join('|')}|Sept)\s+(\d\d\d\d)/i

  VOLUME_PATTERN = /vol\s*(\d+)/i
  ALT_VOLUME_PATTERN = /^(\d+)\sH(L|C)/

  COLUMN_PATTERN = /c\.?(?:olumns? )?(\d+)(\s*(-|–)\s*(\d+))?/i

  SERIES_PATTERN = /\((\S+)\s+series\)/i

  WRITTEN_STATEMENT_PATTERN = /\d\s*WS/i

  WRITTEN_ANSWER_PATTERN = /\d\s*W/i

  WESTMINSTER_HALL_PATTERN = /\d\s*WH/i

  GRAND_COMMITTEE_PATTERN = /\d\s*GC/i

  COLUMN_NUMBER_PATTERN = / (c?c) (\d)/

  class << self

    def create_from text
      attributes = {}
      text = text.tr('.,','')
      if (match = COLUMN_NUMBER_PATTERN.match text)
        text.sub!(match[0], ' '+match[1]+match[2])
      end

      populate_house attributes, text
      populate_date attributes, text

      if attributes.has_key?(:house) || attributes.has_key?(:date)
        if match = VOLUME_PATTERN.match(text)
          attributes[:volume] = match[1].to_i
        elsif match = ALT_VOLUME_PATTERN.match(text)
          attributes[:volume] = match[1].to_i
        end

        attributes[:column], attributes[:end_column] = find_columns text

        if match = SERIES_PATTERN.match(text)
          attributes[:series] = match[1]
        end

        if WRITTEN_STATEMENT_PATTERN.match(text)
          attributes[:written_statement] = true
        elsif WESTMINSTER_HALL_PATTERN.match(text)
          attributes[:westminster_hall] = true
        elsif WRITTEN_ANSWER_PATTERN.match(text)
          attributes[:written_answer] = true
        elsif GRAND_COMMITTEE_PATTERN.match(text)
          attributes[:grand_committee] = true
        end
      end

      reference = HansardReference.new(attributes)
      if reference.is_reference?
        reference
      else
        nil
      end
    end

    private

      def find_columns text
        start_column = end_column = nil

        if match = COLUMN_PATTERN.match(text)
          start_text = match[1]
          start_column = start_text.to_i
          end_text = match[4]

          if end_text
            end_number = end_text.to_i
            number_represents_significant_digits = (end_number < start_column)

            if number_represents_significant_digits
              placeholder = ''
              end_text.size.times {|i| placeholder += '0'}
              base_number = (start_text[0, start_text.length - end_text.size] + placeholder)
              end_column = base_number.to_i + end_number
            else
              end_column = end_number
            end
          end
        end
        return start_column, end_column
      end

      def populate_house attributes, text
        if match = REFERENCE_PATTERN.match(text)
          house_id = match[1].upcase
          if house_id == 'C'
            attributes[:house] = :commons
          elsif house_id == 'L'
            attributes[:house] = :lords
          end
        end
      end

      def populate_date attributes, text
        if match = DATE_PATTERN.match(text)
          month = match[2].capitalize
          month_index = if month == 'Sept'
                          9
                        elsif MONTHS.index(month)
                          MONTHS.index(month) + 1
                        elsif SHORT_MONTHS.index(month)
                          SHORT_MONTHS.index(month) + 1
                        end

          attributes[:date] = Date.new(match[match.size - 1].to_i, month_index, match[1].to_i)
        end
      end
  end

  public

  def session_years
    if house == :commons
      commons_session_years(date).sub('-','')
    elsif house == :lords
      lords_session_years(date).sub('-','')
    end
  end

  def yymmdd
    "#{date.year.to_s[2..3]}#{zero_padded_digit(date.month)}#{zero_padded_digit(date.day)}"
  end

  def commons_session_years date
    commons_sessions = [
        [Date.new(1997,12, 1),Date.new(1998,10,31),'1997-98'],
        [Date.new(1998,11, 1),Date.new(1999,10,31),'1998-99'],
        [Date.new(1999,11, 1),Date.new(2000,11,30),'1999-2000'],
        [Date.new(2000,12, 1),Date.new(2001, 5,31),'2000-01'],
        [Date.new(2001, 6, 1),Date.new(2002,11, 6),'2001-02'],
        [Date.new(2002,11,15),Date.new(2003,11,30),'2002-03'],
        [Date.new(2003,12, 1),Date.new(2004,11,18),'2003-04'],
        [Date.new(2004,11,25),Date.new(2005,04,30),'2004-05'],
        [Date.new(2005, 5, 1),Date.new(2006,11, 8),'2005-06'],
        [Date.new(2006,11,20),Date.new(2007,10,31),'2006-07'],
        [Date.new(2007,11, 1),Date.new(2008, 7,31),'2007-08']]

    commons_sessions.each do |session_dates|
      if date >= session_dates[0]
        if date <= session_dates[1]
          return session_dates[2]
        end
      end
    end
    return nil
  end

  def lords_session_years date
    lords_sessions = [
        [Date.new(1998, 1, 1),Date.new(1998,11,30),'1997-98'],
        [Date.new(1998,12, 1),Date.new(1999,11,30),'1998-99'],
        [Date.new(1999,12, 1),Date.new(2000,11,30),'1999-2000'],
        [Date.new(2000,12, 1),Date.new(2001, 5,31),'2000-01'],
        [Date.new(2001, 6, 1),Date.new(2002,11, 7),'2001-02'],
        [Date.new(2002,11,13),Date.new(2003,11,30),'2002-03'],
        [Date.new(2003,12, 1),Date.new(2004,11,18),'2003-04'],
        [Date.new(2004,11,23),Date.new(2005,05,10),'2004-05'],
        [Date.new(2005, 5,11),Date.new(2006,11, 8),'2005-06'],
        [Date.new(2006,11,16),Date.new(2007,10,31),'2006-07'],
        [Date.new(2007,11, 1),Date.new(2008, 7,31),'2007-08']]
    lords_sessions.each do |session_dates|
      if date >= session_dates[0]
        if date <= session_dates[1]
          return session_dates[2]
        end
      end
    end
    return nil
  end

  def initialize attributes
    @house  = attributes[:house]
    @date   = attributes[:date]
    @column = attributes[:column]
    @end_column = attributes[:end_column]
    @volume = attributes[:volume] if attributes[:volume]
    @series = attributes[:series] if attributes[:series]
    @written_statement = attributes[:written_statement] if attributes[:written_statement]
    @written_answer = attributes[:written_answer] if attributes[:written_answer]
    @westminster_hall = attributes[:westminster_hall] if attributes[:westminster_hall]
    @grand_committee = attributes[:grand_committee] if attributes[:grand_committee]
  end

  def is_reference?
    (@date and @column) ? true : false
  end

  def is_written_statement?
    @written_statement ? true : false
  end

  def is_written_answer?
    @written_answer ? true : false
  end

  def is_westminster_hall?
    @westminster_hall ? true : false
  end

  def is_grand_committee?
    @grand_committee ? true : false
  end

  def year
    @date.year
  end

  def date_to_s
    @date.day.to_s + ' ' + MONTHS[@date.month - 1] + ' ' + @date.year.to_s
  end

  private

    def zero_padded_digit(digit)
      digit < 10 ? "0"+ digit.to_s : digit.to_s
    end

end
