require File.dirname(__FILE__) + '/../spec_helper'

describe RecordsController do

  def self.get_request_should_be_successful
    eval %Q|    it "should be successful" do
      do_get
      response.should be_success
    end|
  end
  def self.should_render_template template_name
    eval %Q|    it "should render #{template_name} template" do
      do_get
      response.should render_template('#{template_name}')
    end|
  end


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

    get_request_should_be_successful
    should_render_template('search')
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

    get_request_should_be_successful
    should_render_template('search_results')

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

    get_request_should_be_successful
    should_render_template('index')

    it "should find all records" do
      Record.should_receive(:find).with(:all).and_return([@record])
      do_get
    end
    it "should assign the found records for the view" do
      do_get
      assigns[:records].should == [@record]
    end

    describe "in atom format" do
      def do_get
        get :index, :format => 'atom'
      end
      it "should be successful" do
        do_get
        response.should be_success
      end
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

    get_request_should_be_successful
    should_render_template('show')

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
      controller.stub!(:is_admin?).and_return true
      @record = mock_model(Record)
      Record.stub!(:new).and_return(@record)
    end

    describe 'and user not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it "should redirect to root" do
        do_get
        response.should redirect_to('http://test.host/')
      end
    end
    def do_get
      get :new
    end

    get_request_should_be_successful
    should_render_template('new')

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
      controller.stub!(:is_admin?).and_return true
      @record = mock_model(Record)
      Record.stub!(:find).and_return(@record)
    end

    def do_get
      get :edit, :id => "1"
    end

    describe 'and user not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it "should redirect to search action" do
        do_get
        response.should redirect_to('http://test.host/')
      end
    end

    get_request_should_be_successful
    should_render_template('edit')

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
      controller.stub!(:is_admin?).and_return true
      @record = mock_model(Record, :to_param => "1")
      Record.stub!(:new).and_return(@record)
    end

    describe 'and user not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it "should redirect to search action" do
        post :create, :record => {}
        response.should redirect_to('http://test.host/')
      end
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
      controller.stub!(:is_admin?).and_return true
      @record = mock_model(Record, :to_param => "1")
      Record.stub!(:find).and_return(@record)
    end

    describe 'and user not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it "should redirect to search action" do
        put :update, :id => "1"
        response.should redirect_to('http://test.host/')
      end
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
      controller.stub!(:is_admin?).and_return true
      @record = mock_model(Record, :destroy => true)
      Record.stub!(:find).and_return(@record)
    end

    def do_delete
      delete :destroy, :id => "1"
    end

    describe 'and user not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it "should redirect to search action" do
        do_delete
        response.should redirect_to('http://test.host/')
      end
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

    get_request_should_be_successful

    it 'should assign record notes to note' do
      do_get
      assigns[:notes].should == @notes
    end
  end

  describe "when posted with records notes to set" do
    before do
      controller.stub!(:is_admin?).and_return true
      @new_notes = "new_notes"
      @record = mock_model(Record, :to_param => "1", :notes=>@new_notes)
      Record.stub!(:find).and_return(@record)
    end

    def do_post
      @record.should_receive(:notes=).with(@new_notes)
      @record.should_receive(:save!)
      post :set_record_notes, :id => "1", :value => @new_notes
    end

    describe 'and user not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it "should redirect to search action" do
        post :set_record_notes, :id => "1", :value => @new_notes
        response.should redirect_to('http://test.host/')
      end
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

  describe "when posted to toggle admin action" do
    def do_post
      post :toggle_admin
    end
    it 'should be successful' do
      do_post
      response.should be_redirect
    end
    it "should redirect to root" do
      do_post
      response.should redirect_to('http://test.host/')
    end
    describe "and session is_admin is nil" do
      it 'should set session is_admin to true' do
        session[:is_admin] = nil
        do_post
        session[:is_admin].should be_true
      end
    end
    describe "and session is_admin is false" do
      it 'should set session is_admin to true' do
        session[:is_admin] = false
        do_post
        session[:is_admin].should be_true
      end
    end
    describe "and session is_admin is true" do
      it 'should set session is_admin to false' do
        session[:is_admin] = true
        do_post
        session[:is_admin].should be_false
      end
    end
  end
end
