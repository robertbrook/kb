require File.dirname(__FILE__) + '/../spec_helper'

describe RecordsController do
  describe "when finding route for action" do
    def self.check_route_for_action action, uri_end=nil, id_param=nil, uri_id=nil
      eval %Q|it "should map { :controller => 'records', :action => '#{action}' #{id_param} } to /records#{uri_end}" do
        route_for(:controller => "records", :action => "#{action}" #{id_param}).should == "/records#{uri_id}#{uri_end}"
      end|
    end
    def self.check_route_for_record_action action, uri_end=nil
      check_route_for_action action, uri_end, id_param=', :id => 1', uri_id='/1'
    end

    it 'should map records search to root' do
      route_for(:controller=>'records', :action=>'search').should == '/'
    end
    it 'should map records search to root' do
      route_for(:controller=>'records', :action=>'search', :s=>'term').should == '/?s=term'
    end

    describe "with no record id specified" do
      check_route_for_action 'index'
      check_route_for_action 'new', '/new'
    end
    describe "with record id specified" do
      check_route_for_record_action 'show'
      check_route_for_record_action 'edit', '/edit'
      check_route_for_record_action 'update'
      check_route_for_record_action 'destroy'
    end
  end

  describe "when asked to get records search page" do
    def do_get
      get :search
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it "should render search template" do
      do_get
      response.should render_template('search')
    end
  end

  describe "when asked for records matching a search term" do
    before do
      @term = 'term'
      @record = mock_model(Record)
      Record.stub!(:find_all_by_name_like).and_return([@record])
    end
    def do_get
      get :search, :s => @term
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it "should render search results template" do
      do_get
      response.should render_template('search_results')
    end
    it "should assign the found records for the view" do
      do_get
      assigns[:records].should == [@record]
    end
    it 'should assign the search term to the view' do
      do_get
      assigns[:term].should == @term
    end
  end

  describe "when asked to get records index" do
    before do
      @record = mock_model(Record, :initial=>'A')
      Record.stub!(:find).and_return([@record])
    end

    def do_get
      get :index
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it "should render index template" do
      do_get
      response.should render_template('index')
    end
    it "should find all records" do
      Record.should_receive(:find).with(:all).and_return([@record])
      do_get
    end
    it "should assign the found records for the view" do
      do_get
      assigns[:records].should == [@record]
    end
  end

  describe "when asked to get a record by its id" do
    before do
      @record = mock_model(Record)
      Record.stub!(:find).and_return(@record)
    end

    def do_get
      get :show, :id => "1"
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
    it "should find the record requested" do
      Record.should_receive(:find).with("1").and_return(@record)
      do_get
    end
    it "should assign the found record for the view" do
      do_get
      assigns[:record].should equal(@record)
    end
  end

  describe "when asked to get a new record" do
    before do
      @record = mock_model(Record)
      Record.stub!(:new).and_return(@record)
    end

    def do_get
      get :new
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
    it "should create an new record" do
      Record.should_receive(:new).and_return(@record)
      do_get
    end
    it "should not save the new record" do
      @record.should_not_receive(:save)
      do_get
    end
    it "should assign the new record for the view" do
      do_get
      assigns[:record].should equal(@record)
    end
  end

  describe "asked to get for editing a record given its id" do
    before do
      @record = mock_model(Record)
      Record.stub!(:find).and_return(@record)
    end

    def do_get
      get :edit, :id => "1"
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
    it "should find the record requested" do
      Record.should_receive(:find).and_return(@record)
      do_get
    end
    it "should assign the found record for the view" do
      do_get
      assigns[:record].should equal(@record)
    end
  end

  describe "when posted a new record" do
    before do
      @record = mock_model(Record, :to_param => "1")
      Record.stub!(:new).and_return(@record)
    end

    def post_with_successful_save
      @record.should_receive(:save).and_return(true)
      post :create, :record => {}
    end
    def post_with_failed_save
      @record.should_receive(:save).and_return(false)
      post :create, :record => {}
    end
    it "should create a new record" do
      Record.should_receive(:new).with({}).and_return(@record)
      post_with_successful_save
    end
    it "should redirect to the new record on successful save" do
      post_with_successful_save
      response.should redirect_to(record_url("1"))
    end
    it "should re-render 'new' on failed save" do
      post_with_failed_save
      response.should render_template('new')
    end
  end

  describe "when put a existing record with updated attributes" do
    before do
      @record = mock_model(Record, :to_param => "1")
      Record.stub!(:find).and_return(@record)
    end

    def put_with_successful_update
      @record.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1"
    end
    def put_with_failed_update
      @record.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1"
    end
    it "should find the record requested" do
      Record.should_receive(:find).with("1").and_return(@record)
      put_with_successful_update
    end
    it "should update the found record" do
      put_with_successful_update
      assigns(:record).should equal(@record)
    end
    it "should assign the found record for the view" do
      put_with_successful_update
      assigns(:record).should equal(@record)
    end
    it "should redirect to the record on successful update" do
      put_with_successful_update
      response.should redirect_to(record_url("1"))
    end
    it "should re-render 'edit' on failed update" do
      put_with_failed_update
      response.should render_template('edit')
    end
  end

  describe "when asked to delete an existing record" do
    before do
      @record = mock_model(Record, :destroy => true)
      Record.stub!(:find).and_return(@record)
    end

    def do_delete
      delete :destroy, :id => "1"
    end
    it "should find the record requested" do
      Record.should_receive(:find).with("1").and_return(@record)
      do_delete
    end
    it "should call destroy on the found record" do
      @record.should_receive(:destroy)
      do_delete
    end
    it "should redirect to the records list" do
      do_delete
      response.should redirect_to(records_url)
    end
  end

  describe "when asked to get records notes" do
    before do
      @notes = "notes"
      @record = mock_model(Record, :to_param => "1", :notes => @notes)
      Record.stub!(:find).and_return(@record)
    end

    def do_get
      get :get_record_notes, :id => "1"
    end
    it "should be successful" do
      do_get
      response.should be_success
    end
    it 'should assign record notes to note' do
      do_get
      assigns[:notes].should == @notes
    end
  end

  describe "when posted with records notes to set" do
    before do
      @new_notes = "new_notes"
      @record = mock_model(Record, :to_param => "1", :notes=>@new_notes)
      Record.stub!(:find).and_return(@record)
    end

    def do_post
      @record.should_receive(:notes=).with(@new_notes)
      @record.should_receive(:save!)
      post :set_record_notes, :id => "1", :value => @new_notes
    end
    it "should be successful" do
      do_post
      response.should be_success
    end
    it 'should assign record notes to note' do
      do_post
      assigns[:record].should == @record
    end
  end
end
