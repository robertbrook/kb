require File.dirname(__FILE__) + '/../spec_helper'

describe HansardReference, 'when creating a reference' do

  def should_match text
    reference = HansardReference.create_from(text)
    reference.should_not be_nil
  end

  def should_not_match text
    reference = HansardReference.create_from(text)
    reference.should be_nil
  end

  def should_match_house text, house
    HansardReference.create_from(text).house.should == house
  end

  def should_match_date text, date
    HansardReference.create_from(text).date.to_s.should == date
  end

  def should_match_volume text, volume
    HansardReference.create_from(text).volume.should == volume
  end

  def should_match_column text, column
    HansardReference.create_from(text).column.should == column
  end

  def should_match_end_column text, column
    HansardReference.create_from(text).end_column.should == column
  end

  def should_match_series text, series
    HansardReference.create_from(text).series.should == series
  end

  def should_identify_written_statement text, written
    HansardReference.create_from(text).is_written_statement?.should == written
  end

  def should_identify_written_answer text, written
    HansardReference.create_from(text).is_written_answer?.should == written
  end

  def should_identify_westminster_hall text, westminster_hall
    HansardReference.create_from(text).is_westminster_hall?.should == westminster_hall
  end

  def should_identify_grand_committee text, grand_committee
    HansardReference.create_from(text).is_grand_committee?.should == grand_committee
  end

  # checking matches #

  it 'should match date in "27 October 2003, Official Report, column 55W"' do
    should_match '27 October 2003, Official Report, column 55W'
  end

  it 'should match on "10 February 2004, Official Report, columns 1293–98W"' do
    should_match '10 February 2004, Official Report, columns 1293–98W'
  end

  it 'should match on "15 January 1986, c. 580"' do
    should_match '15 January 1986, c. 580'
  end

  it 'should match on "15 jan 1986 c580"' do
    should_match '15 jan 1986 c580'
  end

  it 'should match on "hc deb 12 December 2005 c1090"' do
    should_match 'hc deb 2 December 2005 c1090'
  end

  it 'should match on "HC Deb 12 December 2005 c1090"' do
    should_match 'HC Deb 2 December 2005 c1090'
  end

  it 'should match on "HC Deb 12 December 2005 cc1090-4"' do
    should_match 'HC Deb 12 December 2005 cc1090-4'
  end

  it 'should match on "HL Deb 20 July 2005 c111WA"' do
    should_match 'HL Deb 20 July 2005 c111WA'
  end

  it 'should match on "HL Deb 20 July 2005 c111 WS"' do
    should_match 'HL Deb 20 July 2005 c111 WS'
  end

  it 'should match on "HL Deb 20 July 2005 c111ws"' do
    should_match 'HL Deb 20 July 2005 c111ws'
  end

  it 'should match on "HL Deb 20 July 2005 c111 ws"' do
    should_match 'HL Deb 20 July 2005 c111 ws'
  end

  it 'should match on "HL Deb 20 July 2005 c111WS"' do
    should_match 'HL Deb 20 July 2005 c111WS'
  end

  it 'should match on "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match 'HC Deb 11 November 2004 vol 426 cc928-9W'
  end

  it 'should match on "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_match 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84'
  end

  it 'should match on "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_match 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.'
  end

  it 'should match on "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match '468 H.L. Deb., cc.390-1, 14 November 1985.'
  end

  it 'should match on "HC Deb. 19 July 2006 (vol.449) cc.517-518W"' do
    should_match 'HC Deb. 19 July 2006 (vol.449) cc.517-518W'
  end

  it 'should match on "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match 'HC Deb., 14 June 2000, cc 645-6 w'
  end

  it 'should not match "H C Deb 1958-59 December 1958"' do
    should_not_match 'H C Deb 1958-59 December 1958'
  end

  # checking identifies house #

  it 'should not identify house from "15 January 1986, c. 580"' do
    should_match_house '15 January 1986, c. 580', nil
  end

  it 'should identify house from "hc deb 12 December 2005 c1090"' do
    should_match_house 'hc deb 2 December 2005 c1090', :commons
  end

  it 'should identify house from "HC Deb 12 December 2005 c1090"' do
    should_match_house 'HC Deb 2 December 2005 c1090', :commons
  end

  it 'should identify house from "HL Deb 20 July 2005 c111WA"' do
    should_match_house 'HL Deb 20 July 2005 c111WA', :lords
  end

  it 'should identify house from "HL Deb 20 July 2005 c111WS"' do
    should_match_house 'HL Deb 20 July 2005 c111WS', :lords
  end

  it 'should identify house from "HC. Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match_house 'HC. Deb 11 November 2004 vol 426 cc928-9W', :commons
  end

  it 'should identify house from "H.C Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match_house 'H.C Deb 11 November 2004 vol 426 cc928-9W', :commons
  end

  it 'should identify house from "H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match_house 'H.L. Deb., cc.390-1, 14 November 1985.', :lords
  end

  it 'should identify house from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match_house 'HC Deb., 14 June 2000, cc 645-6 w', :commons
  end

  it 'should not identify house from "10 February 2004, Official Report, columns 1293–98W"' do
    should_match_house '10 February 2004, Official Report, columns 1293–98W', nil
  end

  it 'should not identify house from "27 October 2003, Official Report, column 55W"' do
    should_match_house '27 October 2003, Official Report, column 55W', nil
  end

  # checking identifies date #

  it 'should match date in "15 January 1986, c. 580"' do
    should_match_date '15 January 1986, c. 580', '1986-01-15'
  end

  it 'should match date in "HC Deb 12 December 2005 c1090"' do
    should_match_date 'HC Deb 2 December 2005 c1090', '2005-12-02'
  end

  it 'should match date in "HL Deb 20 July 2005 c111WA"' do
    should_match_date 'HL Deb 20 July 2005 c111WA', '2005-07-20'
  end

  it 'should match date in "HL Deb 20 July 2005 c111WS"' do
    should_match_date 'HL Deb 20 July 2005 c111WS', '2005-07-20'
  end

  it 'should match date in "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_match_date 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', '1904-05-02'
  end

  it 'should match date in "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_match_date 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', '1999-12-15'
  end

  it 'should match date in "H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match_date 'H.L. Deb., cc.390-1, 14 November 1985.', '1985-11-14'
  end

  it 'should match date in "HC Deb 19 Sept 2006 (vol449) cc517-518W"' do
    should_match_date 'HC Deb 19 Sept 2006 (vol449) cc517-518W', '2006-09-19'
  end

  it 'should match date in "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match_date 'HC Deb., 14 June 2000, cc 645-6 w', '2000-06-14'
  end

  it 'should match date in "10 February 2004, Official Report, columns 1293–98W"' do
    should_match_date '10 February 2004, Official Report, columns 1293–98W', '2004-02-10'
  end

  it 'should match date in "27 October 2003, Official Report, column 55W"' do
    should_match_date '27 October 2003, Official Report, column 55W', '2003-10-27'
  end

  # checking identifies volume #

  it 'should not identify volume from "15 January 1986, c. 580"' do
    should_match_volume '15 January 1986, c. 580', nil
  end

  it 'should not identify volume from "HC Deb 12 December 2005 c1090"' do
    should_match_volume 'HC Deb 2 December 2005 c1090', nil
  end

  it 'should not identify volume from "HC Deb 12 December 2005 cc1090-4"' do
    should_match_volume 'HC Deb 12 December 2005 cc1090-4', nil
  end

  it 'should not identify volume from "HL Deb 20 July 2005 c111WA"' do
    should_match_volume 'HL Deb 20 July 2005 c111WA', nil
  end

  it 'should not identify volume from "HL Deb 20 July 2005 c111WS"' do
    should_match_volume 'HL Deb 20 July 2005 c111WS', nil
  end

  it 'should identify volume from "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match_volume 'HC Deb 11 November 2004 vol 426 cc928-9W', 426
  end

  it 'should identify volume from "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_match_volume 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', 134
  end

  it 'should identify volume from "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_match_volume 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', 341
  end

  it 'should identify volume from "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match_volume '468 H.L. Deb., cc.390-1, 14 November 1985.', 468
  end

  it 'should identify volume from "HC Deb. 19 July 2006 (vol.449) cc.517-518W"' do
    should_match_volume 'HC Deb. 19 July 2006 (vol.449) cc.517-518W', 449
  end

  it 'should not identify volume from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match_volume 'HC Deb., 14 June 2000, cc 645-6 w', nil
  end

  it 'should not identify volume from "10 February 2004, Official Report, columns 1293–98W"' do
    should_match_volume '10 February 2004, Official Report, columns 1293–98W', nil
  end

  it 'should not identify volume from "27 October 2003, Official Report, column 55W"' do
    should_match_volume '27 October 2003, Official Report, column 55W', nil
  end

  # checking identifies column #

  it 'should identify column from "15 January 1986, c. 580"' do
    should_match_column '15 January 1986, c. 580', 580
  end

  it 'should identify column from "HC Deb 12 December 2005 c1090"' do
    should_match_column 'HC Deb 2 December 2005 c1090', 1090
  end

  it 'should identify column from "HC Deb 12 December 2005 cc1090-4"' do
    should_match_column 'HC Deb 12 December 2005 cc1090-4', 1090
  end

  it 'should identify column from "HL Deb 20 July 2005 c111WA"' do
    should_match_column 'HL Deb 20 July 2005 c111WA', 111
  end

  it 'should identify column from "HL Deb 20 July 2005 c111WS"' do
    should_match_column 'HL Deb 20 July 2005 c111WS', 111
  end

  it 'should identify column from "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match_column 'HC Deb 11 November 2004 vol 426 cc928-9W', 928
  end

  it 'should identify column from "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_match_column 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', 76
  end

  it 'should identify column from "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_match_column 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', 305
  end

  it 'should identify column from "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match_column '468 H.L. Deb., cc.390-1, 14 November 1985.', 390
  end

  it 'should identify column from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match_column 'HC Deb., 14 June 2000, cc 645-6 w', 645
  end

  it 'should identify column from "10 February 2004, Official Report, columns 1293–98W"' do
    should_match_column '10 February 2004, Official Report, columns 1293–98W', 1293
  end

  it 'should identify column from "27 October 2003, Official Report, column 55W"' do
    should_match_column '27 October 2003, Official Report, column 55W', 55
  end


  # checking identifies column #

  it 'should identify column from "15 January 1986, c. 580"' do
    should_match_end_column '15 January 1986, c. 580', nil
  end

  it 'should identify column from "HC Deb 12 December 2005 c1090"' do
    should_match_end_column 'HC Deb 2 December 2005 c1090', nil
  end

  it 'should identify column from "HC Deb 12 December 2005 cc1090-4"' do
    should_match_end_column 'HC Deb 12 December 2005 cc1090-4', 1094
  end

  it 'should identify column from "HL Deb 20 July 2005 c111WA"' do
    should_match_end_column 'HL Deb 20 July 2005 c111WA', nil
  end

  it 'should identify column from "HL Deb 20 July 2005 c111WS"' do
    should_match_end_column 'HL Deb 20 July 2005 c111WS', nil
  end

  it 'should identify column from "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match_end_column 'HC Deb 11 November 2004 vol 426 cc928-9W', 929
  end

  it 'should identify column from "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_match_end_column 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', 84
  end

  it 'should identify column from "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_match_end_column 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', 338
  end

  it 'should identify column from "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match_end_column '468 H.L. Deb., cc.390-1, 14 November 1985.', 391
  end

  it 'should identify column from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match_end_column 'HC Deb., 14 June 2000, cc 645-6 w', 646
  end

  it 'should identify column from "10 February 2004, Official Report, columns 1293–98W"' do
    should_match_end_column '10 February 2004, Official Report, columns 1293–98W', 1298
  end

  it 'should identify column from "27 October 2003, Official Report, column 55W"' do
    should_match_end_column '27 October 2003, Official Report, column 55W', nil
  end

  # checking identifies series #

  it 'should not identify series from "15 January 1986, c. 580"' do
    should_match_series '15 January 1986, c. 580', nil
  end

  it 'should not identify series from "HC Deb 12 December 2005 c1090"' do
    should_match_series 'HC Deb 2 December 2005 c1090', nil
  end

  it 'should not identify series from "HC Deb 12 December 2005 cc1090-4"' do
    should_match_series 'HC Deb 12 December 2005 cc1090-4', nil
  end

  it 'should not identify series from "HL Deb 20 July 2005 c111WA"' do
    should_match_series 'HL Deb 20 July 2005 c111WA', nil
  end

  it 'should not identify series from "HL Deb 20 July 2005 c111WS"' do
    should_match_series 'HL Deb 20 July 2005 c111WS', nil
  end

  it 'should not identify series from "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_match_series 'HC Deb 11 November 2004 vol 426 cc928-9W', nil
  end

  it 'should identify series from "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_match_series 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', '4th'
  end

  it 'should not identify series from "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_match_series 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', nil
  end

  it 'should not identify series from "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_match_series '468 H.L. Deb., cc.390-1, 14 November 1985.', nil
  end

  it 'should not identify series from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_match_series 'HC Deb., 14 June 2000, cc 645-6 w', nil
  end

  it 'should not identify series from "10 February 2004, Official Report, columns 1293–98W"' do
    should_match_series '10 February 2004, Official Report, columns 1293–98W', nil
  end

  it 'should not identify series from "27 October 2003, Official Report, column 55W"' do
    should_match_series '27 October 2003, Official Report, column 55W', nil
  end


  # checking identifies written statement #

  it 'should identify whether written statement from "HC Deb 12 December 2005 c1090"' do
    should_identify_written_statement 'HC Deb 2 December 2005 c1090', false
  end

  it 'should identify whether written statement from "HC Deb 12 December 2005 cc1090-4"' do
    should_identify_written_statement 'HC Deb 12 December 2005 cc1090-4', false
  end

  it 'should identify whether written statement from "HL Deb 20 July 2005 c111WA"' do
    should_identify_written_statement 'HL Deb 20 July 2005 c111WA', false
  end

  it 'should identify whether written statement from "HL Deb 20 July 2005 c111 WS"' do
    should_identify_written_statement 'HL Deb 20 July 2005 c111 WS', true
  end

  it 'should identify whether written statement from "HL Deb 20 July 2005 c111ws"' do
    should_identify_written_statement 'HL Deb 20 July 2005 c111ws', true
  end

  it 'should identify whether written statement from "HL Deb 20 July 2005 c111 ws"' do
    should_identify_written_statement 'HL Deb 20 July 2005 c111 ws', true
  end

  it 'should identify whether written statement from "HL Deb 20 July 2005 c111WS"' do
    should_identify_written_statement 'HL Deb 20 July 2005 c111WS', true
  end

  it 'should identify whether written statement from "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_identify_written_statement 'HC Deb 11 November 2004 vol 426 cc928-9W', false
  end

  it 'should identify whether written statement from "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_identify_written_statement 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', false
  end

  it 'should identify whether written statement from "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_identify_written_statement 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', false
  end

  it 'should identify whether written statement from "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_identify_written_statement '468 H.L. Deb., cc.390-1, 14 November 1985.', false
  end

  it 'should not identify written statement from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_identify_written_statement 'HC Deb., 14 June 2000, cc 645-6 w', false
  end

  it 'should not identify written statement from "10 February 2004, Official Report, columns 1293–98W"' do
    should_identify_written_statement '10 February 2004, Official Report, columns 1293–98W', false
  end

  it 'should not identify written statement from "27 October 2003, Official Report, column 55W"' do
    should_identify_written_statement '27 October 2003, Official Report, column 55W', false
  end


  # checking identifies written answer #

   it 'should not identitfy as written answer "HC Deb 18 Oct 1971 c343"' do
     should_identify_written_answer 'HC Deb 18 Oct 1971 c343', false
   end

  it 'should identify whether written answer from "HC Deb 12 December 2005 c1090"' do
    should_identify_written_answer 'HC Deb 2 December 2005 c1090', false
  end

  it 'should identify whether written answer from "HC Deb 12 December 2005 cc1090-4"' do
    should_identify_written_answer 'HC Deb 12 December 2005 cc1090-4', false
  end

  it 'should identify whether written answer from "HL Deb 20 July 2005 c111WA"' do
    should_identify_written_answer 'HL Deb 20 July 2005 c111WA', true
  end

  it 'should identify whether written answer from "HL Deb 20 July 2005 c111WS"' do
    should_identify_written_answer 'HL Deb 20 July 2005 c111WS', false
  end

  it 'should identify whether written answer from "HC Deb 11 November 2004 vol 426 cc928-9W"' do
    should_identify_written_answer 'HC Deb 11 November 2004 vol 426 cc928-9W', true
  end

  it 'should identify whether written answer from "HL Deb (4th series) 2 May 1904 vol 134 cc76-84"' do
    should_identify_written_answer 'HL Deb (4th series) 2 May 1904 vol 134 cc76-84', false
  end

  it 'should identify whether written answer from "HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338."' do
    should_identify_written_answer 'HC Deb, 15 Dec 1999, Vol. 341, cc. 305-338.', false
  end

  it 'should identify whether written answer from "468 H.L. Deb., cc.390-1, 14 November 1985."' do
    should_identify_written_answer '468 H.L. Deb., cc.390-1, 14 November 1985.', false
  end

  it 'should identify whether written answer from "HC Deb., 14 June 2000, cc 645-6 w"' do
    should_identify_written_answer 'HC Deb., 14 June 2000, cc 645-6 w', true
  end

  it 'should identify written answer from "10 February 2004, Official Report, columns 1293–98W"' do
    should_identify_written_answer '10 February 2004, Official Report, columns 1293–98W', true
  end

  it 'should identify written answer from "27 October 2003, Official Report, column 55W"' do
    should_identify_written_answer '27 October 2003, Official Report, column 55W', true
  end


  it 'should identify whether westminster hall from "HC Deb 20 July 2005 c111W"' do
    should_identify_westminster_hall 'HC Deb 20 July 2005 c111W', false
  end

  it 'should identify whether westminster hall from "HC Deb 20 July 2005 c111WH"' do
    should_identify_westminster_hall 'HC Deb 20 July 2005 c111WH', true
  end


  it 'should identify whether grand committee from "HL Deb 20 July 2005 c111WA"' do
    should_identify_grand_committee 'HL Deb 20 July 2005 c111WA', false
  end

  it 'should identify whether grand committee from "HL Deb 20 July 2005 c111GC"' do
    should_identify_grand_committee 'HL Deb 20 July 2005 c111GC', true
  end

  it 'should not create reference from "random text"' do
    HansardReference.create_from('random text').should be_nil
  end
end

describe HansardReference, 'when finding a reference' do

  before do
    @end_column = nil
  end

  def make_reference column, date, house, type={}
    reference = HansardReference.new({
        :column => column,
        :date => date,
        :house => house}.merge(type))
  end

  def default_reference
    date = Date.new(2005,12,2)
    reference = make_reference 580, date, :commons
  end

  it 'should report reference year correctly' do
    year = 2005
    reference = make_reference 1090, Date.new(year,12,2), :commons
    reference.year.should == year
  end

  it 'should display reference date correctly' do
    date = Date.new(2005,12,2)
    reference = make_reference 1090, date, :commons
    reference.date_to_s.should == '2 December 2005'
  end

end
