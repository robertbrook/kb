require File.dirname(__FILE__) + '/../spec_helper'

describe RecordsHelper do

  describe 'when asked to format notes' do
    it 'should add line brake element for single line break' do
      record = mock(Record, :note => "One\r\nTwo")
      format_notes(record).should == '<p>One<br />Two</p>'
    end
    it 'should put paragraphs in paragraph elements' do
      record = mock(Record, :note => "One\r\n\r\nTwo")
      format_notes(record).should == '<p>One</p><p>Two</p>'

      record = mock(Record, :note => "One\r\n\r\nTwo\r\n")
      format_notes(record).should == '<p>One</p><p>Two</p>'
    end
    it 'should turn URIs in to hyperlinks' do
      record = mock(Record, :note => "A http://host/path\r\nwebsite")
      format_notes(record).should == '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'
    end
  end
end
