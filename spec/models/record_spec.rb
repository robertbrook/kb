require File.dirname(__FILE__) + '/../spec_helper'

describe Record do
  before :all do
    @summary = 'Information about EDMs.'
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
      unused_attributes.size.should == 8
    end
  end

  describe 'record with name' do
    before do
      @record.stub!(:name).and_return 'All-Party Groups: Subject'
      @other_record = Record.new
      @records = [@record, @other_record]
    end

    describe 'when validated' do
      it 'should have name set to concatenate of name attributes' do
        @record.valid?.should be_true
        @record.name.should == 'All-Party Groups: Subject'
      end
    end

    describe 'when asked for name' do
      it 'should return name' do
        @record.name.should == "#{@record.name}"
      end
    end

    describe 'when sorted' do
      describe 'with a record that has a different end word' do
        it 'should sort correctly' do
          @other_record.stub!(:name).and_return 'All-Party Groups: Country'
          @records.sort.should == [@other_record, @record]
        end
      end
      describe 'with a record that has a different middle word' do
        it 'should sort correctly' do
          @other_record.stub!(:name).and_return 'All-Party Committee: Subject'
          @records.sort.should == [@other_record, @record]
        end
      end
      describe 'with a record that has a different first word' do
        it 'should sort correctly' do
          @other_record.stub!(:name).and_return 'Advisory Groups: Subject'
          @records.sort.should == [@other_record, @record]
        end
      end
    end
  end

  describe 'record with summary text' do
    before do
      @record.attributes = {:summary => @summary}
    end
    describe 'when asked for summary text' do
      it 'should return summary' do
        @record.summary.should == @summary
      end
    end
    describe 'when asked for notes summary' do
      it 'should return summary text' do
        @record.notes_summary.should == @summary
      end
    end
  end

  describe 'record with notes text' do
    before do
      @record.stub!(:notes).and_return @notes
    end
    describe 'when asked for notes summary' do
      it 'should return first 100 chars of notes attribute' do
        @record.notes_summary.should == @notes[0..99] + '...'
      end
    end

    describe 'when asked for line count' do
      it 'should return count of lines in notes text' do
        @record.line_count.should == @notes.split("\n").size
      end
    end
    describe 'and with web_page set' do
      before do
        @record.stub!(:attributes).and_return({'notes'=>@notes, 'web_page'=>@web_page})
      end
      describe 'when asked for summary_attributes' do
        it 'should not return the notes attribute' do
          @record.summary_attributes.should_not have_key('notes')
        end
        it 'should return the web_page attribute' do
          @record.summary_attributes.should_not have_key('web_page')
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

  describe 'when asked to find all by name or notes like a given term' do
    describe 'when term matches records' do
      it 'should return those records' do
        @term = 'term'
        records = mock('records')
        Record.should_receive(:find).with(:all, :conditions => "name LIKE '%#{@term}%' OR notes LIKE '%#{@term}%'").and_return records
        Record.find_all_by_name_or_notes_like(@term).should == records
      end
    end
    describe 'when term matches no records' do
      it 'should return empty array' do
        @term = 'term'
        records = mock('records')
        Record.should_receive(:find).with(:all, :conditions => "name LIKE '%#{@term}%' OR notes LIKE '%#{@term}%'").and_return []
        Record.find_all_by_name_or_notes_like(@term).should == []
      end
    end
  end

  describe 'when asked to find all by name like a given term' do
    before do
      @term = 'mit'
      @conditions = { :conditions => "name LIKE '%#{@term}%'" }
    end
    describe 'when term matches records' do
      it 'should return those records sorted by name' do
        record1 = mock(Record, :name => 'Mit')
        record2 = mock(Record, :name => 'Mittence')
        @records = [record2, record1]
        @sorted_records = [record1, record2]
        Record.should_receive(:find).with(:all, @conditions).and_return @records
        Record.find_all_by_name_like(@term).should == @sorted_records
      end
    end
    describe 'when term matches no records' do
      it 'should return empty array' do
        Record.should_receive(:find).with(:all, @conditions).and_return []
        Record.find_all_by_name_like(@term).should == []
      end
    end
    describe 'when term matches partial text in record' do
      it 'should return empty array' do
        record = mock(Record, :name => 'Committee')
        Record.should_receive(:find).with(:all, @conditions).and_return [record]
        Record.find_all_by_name_like(@term).should == []
      end
    end
  end

  describe 'when asked for all records needing to be checked' do
    it 'should find and return records needing to be checked' do
      record = mock(Record)
      conditions = { :conditions => 'use_check_by_date = "t" AND check_by_date <= date("now")' }
      Record.should_receive(:find).with(:all,conditions).and_return [record]
      Record.all_needing_check
    end
  end
end
