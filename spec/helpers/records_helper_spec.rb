require File.dirname(__FILE__) + '/../spec_helper'

describe RecordsHelper do

  describe 'when asked to format notes' do
    def check_formatted notes, expected
      record = Record.new :notes => notes
      helper.html_formatted_notes(record).should == expected
    end

    it 'should add linebreak element for single line break' do
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
      check_formatted "A http://host/path\r\nwebsite",
        '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'

      check_formatted "A http://host/path\nwebsite",
        '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'
    end

    describe "notes contain Hansard citation" do
      def check_citation_link citation
        check_formatted citation,
            %Q|<p><a href="http://hansard.millbanksystems.com/search/#{citation}">#{citation}</a></p>|
      end
      it 'should make a single column commons citation a link' do
        check_citation_link "HC Deb 16 September 2004 c1459"
      end
      it 'should make a multi-column commons citation a link' do
        check_citation_link "HC Deb 8 August 1911 cc967-1116"
      end
      it 'should make a single column lords citation a link' do
        check_citation_link "HL Deb 27 April 2006 c27"
      end
      it 'should make a multi-column lords citation a link' do
        check_citation_link "HL Deb 14 June 2005 cc1177-1180"
      end
      it 'should make single column written answer a link' do
        check_citation_link "HC Deb 8 November 2006 c.1527W"
      end
      it 'should make a written answer citation a link' do
        check_citation_link "HC Deb 27 February 1980 vol 979 c 616W"
      end
      it 'should make a written statement citaion a link' do
        check_citation_link "HC Deb 25 October 2007 cc20-1WS"
      end
    end
  end
end
