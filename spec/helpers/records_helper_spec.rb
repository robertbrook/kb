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

    it 'should ignore > char at end of URI' do
      check_formatted "<http://www.boundarycommission.org.uk/members.asp> ",
        '<p>&lt;<a href="http://www.boundarycommission.org.uk/members.asp">http://www.boundarycommission.org.uk/members.asp</a>&gt;</p>'
    end

    it 'should turn URIs in to hyperlinks' do
      check_formatted "A http://host/path\r\nwebsite",
        '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'

      check_formatted "A http://host/path\nwebsite",
        '<p>A <a href="http://host/path">http://host/path</a><br />website</p>'
    end

    describe "notes contain Hansard citation" do
      def check_citation_link citation, date
        hansard_reference = mock('reference', :date => date)
        HansardReference.should_receive(:create_from).with(citation).and_return hansard_reference
        if date > Date.new(2005, 3, 17)
          parliament_uk_url = 'url'
          helper.should_receive(:parliament_uk_url).with(hansard_reference).and_return parliament_uk_url
          check_formatted citation,
              %Q|<p><a href="url">#{citation}</a></p>|
        else
          check_formatted citation,
              %Q|<p><a href="http://hansard.millbanksystems.com/search/#{citation}">#{citation}</a></p>|
        end
      end
      it 'should make a single column commons citation a link' do
        check_citation_link "HC Deb 16 September 2004 c1459", Date.new(2004,9,16)
      end
      it 'should make a multi-column commons citation a link' do
        check_citation_link "HC Deb 8 August 1911 cc967-1116", Date.new(1911,8,8)
      end
      it 'should make a single column lords citation a link' do
        check_citation_link "HL Deb 27 April 2006 c27", Date.new(2006,4,27)
      end
      it 'should make a multi-column lords citation a link' do
        check_citation_link "HL Deb 14 June 2005 cc1177-1180", Date.new(2005,6,14)
      end
      it 'should make single column written answer a link' do
        check_citation_link "HC Deb 8 November 2006 c.1527W", Date.new(2006,11,8)
      end
      it 'should make a written answer citation a link' do
        check_citation_link "HC Deb 27 February 1980 vol 979 c 616W", Date.new(1980,2,27)
      end
      it 'should make a written statement citaion a link' do
        check_citation_link "HC Deb 25 October 2007 cc20-1WS", Date.new(2007,10,25)
      end
    end
  end

  describe 'when asked for parliament.uk url for a given hansard reference' do

    def mock_hansard_reference house, params={}
      default_params = {:house=>house, :date => Date.new(1995, 11, 10), :is_written_statement? => false, :is_written_answer? => false, :is_westminster_hall? => false, :is_grand_committee? => false}
      mock_model(HansardReference, default_params.merge(params))
    end

    describe "and reference is to a Lords sitting" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:lords)
        helper.should_receive(:lords_parliament_uk_url).with(hansard_reference, '')
        helper.parliament_uk_url(hansard_reference)
      end
    end
    describe "and reference is to a Lords written answer" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:lords, :is_written_answer? => true)
        helper.should_receive(:lords_parliament_uk_url).with(hansard_reference, '#start_written')
        helper.parliament_uk_url(hansard_reference)
      end
    end
    describe "and reference is to a Lords written statement" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:lords, :is_written_statement? => true)
        helper.should_receive(:lords_parliament_uk_url).with(hansard_reference, '#start_minist')
        helper.parliament_uk_url(hansard_reference)
      end
    end

    describe "and reference is to a Commons sitting" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:commons)
        helper.should_receive(:commons_parliament_uk_url).with(hansard_reference, 'debindx', 'Debate')
        helper.parliament_uk_url(hansard_reference)
      end
    end
    describe "and reference is to a Commons written answer" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:commons, :is_written_answer? => true)
        helper.should_receive(:commons_parliament_uk_url).with(hansard_reference, 'index', 'Writtens')
        helper.parliament_uk_url(hansard_reference)
      end
    end
    describe "and reference is to a Commons written statement" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:commons, :is_written_statement? => true)
        helper.should_receive(:commons_parliament_uk_url).with(hansard_reference, 'wmsindx', nil)
        helper.parliament_uk_url(hansard_reference)
      end
    end
    describe "and reference is to a Westminster Hall sitting" do
      it 'should link to correct URL' do
        hansard_reference = mock_hansard_reference(:commons, :is_westminster_hall? => true)
        helper.should_receive(:commons_parliament_uk_url).with(hansard_reference, 'hallindx', nil)
        helper.parliament_uk_url(hansard_reference)
      end
    end
  end


=begin
  describe "when linking to a Lords sitting at parliament.uk" do
    it 'should return a http://www.publications.parliament.uk URL if passed a sitting on the date 1995-11-15' do
      volume = mock_model(Volume, :session_start_year => 1995, :session_end_year => 1996)
      sitting = mock_model(Sitting, :date => Date.new(1995, 11, 15),
                                    :volume => volume,
                                    :year => 1995,
                                    :month => 11,
                                    :day => 15)
      expected = "http://www.publications.parliament.uk/pa/ld199596/ldhansrd/vo951115/index/51115-x.htm#test_anchor"
      lords_parliament_uk_url(sitting, "#test_anchor").should == expected
    end

    it 'should return nil if passed the date 1985-11-15' do
      volume = mock_model(Volume, :session_start_year => 1985, :session_end_year => 1986)
      sitting = mock_model(Sitting, :date => Date.new(1985, 11, 15),
                                    :volume => volume,
                                    :year => 1985,
                                    :month => 11,
                                    :day => 15)
      lords_parliament_uk_url(sitting, "#test_anchor").should be_nil
    end

    it 'should return nil if the session start year and end year for the sitting volume are nil' do
      volume = mock_model(Volume, :session_start_year => nil, :session_end_year => nil)
      sitting = mock_model(Sitting, :date => Date.new(1995, 11, 15),
                                     :volume => volume,
                                     :year => 1995,
                                     :month => 11,
                                     :day => 15)
      lords_parliament_uk_url(sitting, "#test_anchor").should be_nil
    end
  end

  describe "when linking to a Commons sitting at parliament.uk" do
    describe 'with a sitting dated after 1995-11-08' do
      it 'should return a http://www.publications.parliament.uk URL' do
        volume = mock_model(Volume, :session_start_year => 1995, :session_end_year => 1996)
        sitting = mock_model(Sitting, :date => Date.new(1995, 11, 10),
                                      :volume => volume,
                                      :year => 1995,
                                      :month => 11,
                                      :day => 10)
        expected = "http://www.publications.parliament.uk/pa/cm199596/cmhansrd/vo951110/debindx/51110-x.htm"
        commons_parliament_uk_url(sitting,'debindx', nil).should == expected
      end
    end

    describe 'with a sitting dated between 1995-11-08 and 1988-11-22' do
      it 'should return a earlier version http://www.publications.parliament.uk URL' do
        volume = mock_model(Volume, :session_start_year => 1994, :session_end_year => 1995)
        sitting = mock_model(Sitting, :date => Date.new(1994, 11, 10),
                                      :volume => volume,
                                      :year => 1994,
                                      :month => 11,
                                      :day => 10, :debates => nil)
        expected = "http://www.publications.parliament.uk/pa/cm199495/cmhansrd/1994-11-10/Debate-1.html"
        commons_parliament_uk_url(sitting,'debindx', 'Debate').should == expected
      end
    end

    describe 'with a sitting dated prior to 1988-11-22' do
      it 'should return nil' do
        volume = mock_model(Volume, :session_start_year => 1985, :session_end_year => 1986)
        sitting = mock_model(Sitting, :date => Date.new(1985, 11, 8),
                                      :volume => volume,
                                      :year => 1985,
                                      :month => 11,
                                      :day => 8)
        commons_parliament_uk_url(sitting,'debindx', nil).should be_nil
      end
    end

    describe 'with a sitting in session that is missing start and end dates' do
      it 'should return nil' do
        volume = mock_model(Volume, :session_start_year => nil, :session_end_year => nil)
        sitting = mock_model(Sitting, :date => Date.new(1995, 11, 10),
                                      :volume => volume,
                                      :year => 1995,
                                      :month => 11,
                                      :day => 10)
        commons_parliament_uk_url(sitting, 'debindx', nil).should be_nil
      end
    end
  end
=end

end
