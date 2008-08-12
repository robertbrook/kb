require File.dirname(__FILE__) + '/../spec_helper'

describe Record do
  before :all do
    @note = %Q|The factsheet states:\n\nMinisters and whips do not normally sign EDMs. Under the Ministerial Code, Parliamentary Private Secretaries ?must not associate themselves with particular groups advocating special policies?, and they do not normally sign EDMs. Neither the Speaker nor Deputy Speakers will sign EDMs. Internal party rules may also affect who can sign early day motions.|
    @web_page = 'http://www.parliament.uk/parliamentary_publications_and_archives/factsheets/p03.cfm'
  end
  before do
    @record = Record.new
  end

  describe 'record with note text' do
    before do
      @record.stub!(:note).and_return @note
    end
    describe 'when asked for note summary' do
      it 'should return first 100 chars of note attribute' do
        @record.note_summary.should == @note[0..99]
      end
    end

    describe 'and with web_page set and title attribute blank' do
      before do
        @record.stub!(:attributes).and_return({'note'=>@note, 'web_page'=>@web_page, 'title'=>''})
      end
      describe 'when asked for non_blank_attributes' do
        it 'should not return the note attribute' do
          @record.non_blank_attributes.should_not have_key('note')
        end
        it 'should return the web_page attribute' do
          @record.non_blank_attributes.should have_key('web_page')
        end
        it 'should not return the title attribute' do
          @record.non_blank_attributes.should_not have_key('title')
        end
      end
    end
  end

  describe 'record without note text' do
    describe 'when asked for note summary' do
      it 'should return an empty string' do
        @record.note_summary.should == ''
      end
    end
  end

end
