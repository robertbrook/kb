require File.dirname(__FILE__) + '/../spec_helper'

describe Record do
  before :all do
    @notes = %Q|The factsheet states:\n\nMinisters and whips do not normally sign EDMs. Under the Ministerial Code, Parliamentary Private Secretaries ?must not associate themselves with particular groups advocating special policies?, and they do not normally sign EDMs. Neither the Speaker nor Deputy Speakers will sign EDMs. Internal party rules may also affect who can sign early day motions.|
    @web_page = 'http://www.parliament.uk/parliamentary_publications_and_archives/factsheets/p03.cfm'
  end
  before do
    @record = Record.new
  end

  describe 'records only having notes populated' do
    describe 'when asked for unused_attributes'
    it 'should return all but the notes attribute' do
      Record.stub!(:first).and_return @record
      Record.stub!(:all).and_return [@record]
      @record.should_receive(:notes).and_return @notes
      unused_attributes = Record.unused_attributes
      unused_attributes.include?('notes').should be_false
      unused_attributes.size.should == 88
    end
  end

  describe 'record with first name, middle name and last name' do
    before do
      @record.stub!(:first_name).and_return 'All-Party'
      @record.stub!(:middle_name).and_return 'Groups:'
      @record.stub!(:last_name).and_return 'Subject'
      @other_record = Record.new
      @records = [@record, @other_record]
    end

    describe 'and title and suffix' do
      before do
        @record.stub!(:title).and_return 'The'
        @record.stub!(:suffix).and_return '(suffix)'
      end
      describe 'when asked for display_title' do
        it 'should append together title, first, middle, last names, and suffix' do
          @record.display_title.should == "#{@record.title} #{@record.first_name} #{@record.middle_name} #{@record.last_name} #{@record.suffix}"
        end
      end
      describe 'when validated' do
        it 'should have name set to concatenate of name attributes' do
          @record.valid?.should be_true
          @record.name.should == 'The All-Party Groups: Subject (suffix)'
        end
      end
    end

    describe 'when validated' do
      it 'should have name set to concatenate of name attributes' do
        @record.valid?.should be_true
        @record.name.should == 'All-Party Groups: Subject'
      end
    end

    describe 'when asked for display_title' do
      it 'should append together first, middle, last names' do
        @record.display_title.should == "#{@record.first_name} #{@record.middle_name} #{@record.last_name}"
      end
    end

    describe 'when sorted' do
      describe 'with a record that has a different last_name' do
        it 'should sort correctly' do
          @other_record.stub!(:first_name).and_return @record.first_name
          @other_record.stub!(:middle_name).and_return @record.middle_name
          @other_record.stub!(:last_name).and_return 'Country'
          @records.sort.should == [@other_record, @record]
        end
      end
      describe 'with a record that has a different middle_name' do
        it 'should sort correctly' do
          @other_record.stub!(:first_name).and_return @record.first_name
          @other_record.stub!(:middle_name).and_return 'Committee'
          @other_record.stub!(:last_name).and_return @record.last_name
          @records.sort.should == [@other_record, @record]
        end
      end
      describe 'with a record that has a different last_name' do
        it 'should sort correctly' do
          @other_record.stub!(:first_name).and_return 'Advisory'
          @other_record.stub!(:middle_name).and_return @record.middle_name
          @other_record.stub!(:last_name).and_return @record.last_name
          @records.sort.should == [@other_record, @record]
        end
      end
    end
  end
  describe 'record with notes text' do
    before do
      @record.stub!(:notes).and_return @notes
    end
    describe 'when asked for notes summary' do
      it 'should return first 100 chars of notes attribute' do
        @record.notes_summary.should == @notes[0..99]
      end
    end

    describe 'and with web_page set and title attribute blank' do
      before do
        @record.stub!(:attributes).and_return({'notes'=>@notes, 'web_page'=>@web_page, 'title'=>''})
      end
      describe 'when asked for summary_attributes' do
        it 'should not return the notes attribute' do
          @record.summary_attributes.should_not have_key('notes')
        end
        it 'should return the web_page attribute' do
          @record.summary_attributes.should_not have_key('web_page')
        end
        it 'should not return the title attribute' do
          @record.summary_attributes.should_not have_key('title')
        end
      end
    end
  end

  describe 'record without notes text' do
    describe 'when asked for notes summary' do
      it 'should return an empty string' do
        @record.notes_summary.should == ''
      end
    end
  end

end
