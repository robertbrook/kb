require File.dirname(__FILE__) + '/../spec_helper'

describe RecordsHelper do
  describe 'when asked to format notes' do
    def check_formatted notes, expected
      record = mock(Record, :note => notes)
      helper.format_notes(record).should == expected
    end

    it 'should add line brake element for single line break' do
      check_formatted "One\r\nTwo", '<p>One<br />Two</p>'
      check_formatted "One\nTwo", '<p>One<br />Two</p>'
    end
    it 'should put paragraphs in paragraph elements' do
      check_formatted "One\r\n\r\nTwo", '<p>One</p><p>Two</p>'
      check_formatted "One\r\n\r\nTwo\r\n", '<p>One</p><p>Two</p>'
      check_formatted "One\n\nTwo", '<p>One</p><p>Two</p>'
      check_formatted "One\n\nTwo\n", '<p>One</p><p>Two</p>'
    end
    it 'should turn URIs in to hyperlinks' do
      check_formatted "A http://host/path\r\nwebsite", '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'
      check_formatted "A http://host/path\nwebsite", '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'
    end
  end
end
