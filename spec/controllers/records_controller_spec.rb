require File.dirname(__FILE__) + '/../spec_helper'

describe RecordsController do

  def self.get_request_should_be_successful
    eval %Q|    it "should be successful" do
      do_get
      response.should be_success
    end|
  end

  def self.get_should_render_template template_name
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
      route_for(:controller=>'records', :action=>'search', :q=>'term').should == '/?q=term'
    end

    describe "with no record id specified" do
      check_route_for_action 'index'
      check_route_for_action 'recent_edits', '/recent_edits'
      check_route_for_action 'new', '/new'
      check_route_for_action 'tag', '/tag'
      check_route_for_action 'status', '/status'
    end
    describe "with record id specified" do
      check_route_for_record_action 'show'
      check_route_for_record_action 'edit', '/edit'
      check_route_for_record_action 'update'
      check_route_for_record_action 'destroy'
    end
  end

  describe 'when asked for non-existant record' do
    it 'should return file not found' do
      get :show, :id => 'bad_id'
      response.code.should == '404'
    end
  end

  describe 'when asked for record using an old slug name' do
    it 'should redirect to new url' do
      record = Record.create :name => 'Knowledge Star'
      record.friendly_id.should == 'knowledge-star'

      record.name = 'Knowledge Base'
      record.save
      record.reload
      record.friendly_id.should == 'knowledge-base'

      get :show, :id => 'knowledge-star'
      response.should redirect_to(:controller=>'records', :action=>'show', :id => 'knowledge-base')
      Record.delete_all
    end
  end

  describe "when asked to get records search page" do
    def do_get
      get :search
    end

    get_request_should_be_successful
    get_should_render_template('search')
    describe 'when user has admin role' do
      before do
        controller.stub!(:is_admin?).and_return true
        Record.stub!(:all_needing_check)
        Record.stub!(:recently_edited)
      end
      it 'should assign all needing check to view' do
        needing_check = mock('needing_check')
        Record.should_receive(:all_needing_check).and_return needing_check
        do_get
        assigns[:records_needing_check].should == needing_check
      end
      it 'should assign recently edited to view' do
        recently_edited = mock('recently_edited')
        Record.should_receive(:recently_edited).and_return recently_edited
        do_get
        assigns[:records_recently_edited].should == recently_edited
      end
    end
    describe 'when user does not have admin role' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it 'should not assign all needing check to view' do
        do_get
        assigns[:records_needing_check].should == nil
      end
      it 'should not assign recently edited to view' do
        do_get
        assigns[:recently_edited].should == nil
      end
    end
  end

  describe "when receiving post of search term" do
    def do_post
      post :search, :q => @term
    end
    describe 'and term is not blank' do
      before do
        @term = 'term'
      end
      it 'should redirect to search result url' do
        do_post
        response.should redirect_to(:controller=>'records', :action=>'search', :query=>'term')
      end
    end
    describe 'and term is blank' do
      before do
        @term = nil
      end
      it 'should render search template' do
        do_post
        response.should render_template('search')
      end
    end
  end

  describe "when asked for records matching a search term" do
    before do
      @term = 'term'
      @record = mock_model(Record,:has_better_id? => false)
    end
    def do_get
      get :search, :query => @term
    end

    describe 'and there are no records matching term' do
      before do
        @matches_estimated = 0
        Record.stub!(:search).and_return [[],[],@matches_estimated,'committee']
      end
      get_request_should_be_successful
      get_should_render_template('search_results')
      it "should assign records as an empty array for the view" do
        do_get
        assigns[:records].should == []
        assigns[:words_to_highlight].should == []
        assigns[:spelling_correction].should == 'committee'
      end
    end

    describe 'and there are records matching term' do
      before do
        @matches_estimated = 1
        Record.stub!(:search).and_return [[@record], [@term], @matches_estimated, nil]
      end
      get_request_should_be_successful
      get_should_render_template('search_results')

      it "should assign the found records for the view" do
        do_get
        assigns[:records].should == [@record]
        assigns[:words_to_highlight].should == [@term]
      end
      it 'should assign the search term to the view' do
        do_get
        assigns[:term].should == @term
      end
    end
  end

  describe "when asked to get records index" do
    before do
      @record = mock_model(Record, :initial=>'A', :has_better_id? => false)
      Record.stub!(:find).and_return([@record])
    end

    def do_get
      get :index
    end

    get_request_should_be_successful
    get_should_render_template('index')

    it "should find all records" do
      Record.should_receive(:find).with(:all, {:order=>"name asc", :offset=>0, :limit=>10}).and_return([@record])
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
      @record = mock_model(Record, :tag_list => [], :status_list => [], :similar_records => [], :has_better_id? => false)
      Record.stub!(:find).and_return(@record)
    end

    def do_get
      get :show, :id => "1"
    end

    get_request_should_be_successful
    get_should_render_template('show')

    it "should find the record requested" do
      Record.should_receive(:find).with("1").twice.and_return(@record)
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
      @record = mock_model(Record,:has_better_id? => false)
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
    get_should_render_template('new')

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
      @record = mock_model(Record,:has_better_id? => false)
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
    get_should_render_template('edit')

    it "should find the record requested" do
      Record.should_receive(:find).twice.and_return(@record)
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
      @record = mock_model(Record, :to_param => "1",:has_better_id? => false)
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
      Record.should_receive(:new).with({"notes"=>nil}).and_return(@record)
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
      Record.should_receive(:find).with("1").twice.and_return(@record)
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
      Record.should_receive(:find).with("1").twice.and_return(@record)
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

  describe "when asked to add tag" do
    before do
      @tag = 'tag'
      @query = 'term'
    end
    def do_post
      post :add_tag, :tag => @tag, :query => @query
    end

    describe 'and user is admin' do
      before do
        controller.stub!(:is_admin?).and_return true
      end
      it 'should add tag to identified records' do
        Record.should_receive(:tag_query_results).with(@query, @tag).and_return [@record]
        do_post
      end
      it 'should redirect to tag view with flash notice set' do
        Record.stub!(:tag_query_results).and_return [@record]
        do_post
        flash[:notice].should == "Adding '#{@tag}' tag successful, 1 record changed."
        response.should redirect_to(:action => 'search', :query => @query)
      end
    end
    describe 'and user is not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it 'should not add tag to identified records' do
        Record.should_not_receive(:add_tag)
        do_post
      end
    end
  end

  describe "when asked to rename tag" do
    before do
      @tag = 'tag'
      @new_tag = 'new tag'
    end
    def do_post
      post :rename_tag, :old_tag => @tag, :new_tag => @new_tag.gsub(' ','_')
    end

    describe 'and user is admin' do
      before do
        controller.stub!(:is_admin?).and_return true
      end
      it 'should rename tag for matching records' do
        Record.should_receive(:rename_tag).with(@tag, @new_tag).and_return [@record]
        do_post
      end
      it 'should redirect to tag view with flash notice set' do
        Record.stub!(:rename_tag).and_return [@record]
        do_post
        flash[:notice].should == "Renaming tag to '#{@new_tag}' successful, 1 record changed."
        response.should redirect_to(:action => 'tag', :id => @new_tag)
      end
    end
    describe 'and user is not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it 'should not rename tag' do
        Record.should_not_receive(:rename_tag)
        do_post
      end
    end
  end

  describe "when asked to delete tag" do
    before do
      @tag = 'tag'
    end
    def do_delete
      delete :delete_tag, :id => @tag
    end

    describe 'and user is admin' do
      before do
        controller.stub!(:is_admin?).and_return true
      end
      it 'should delete tag from all records' do
        Record.should_receive(:delete_tag).with(@tag)
        do_delete
      end
      it 'should redirect to tag view with flash notice set' do
        Record.stub!(:delete_tag).with(@tag)
        do_delete
        flash[:notice].should == "Deletion of '#{@tag}' tags successful."
        response.should redirect_to(:action => 'tag', :id => @tag)
      end
    end
    describe 'and user is not admin' do
      before do
        controller.stub!(:is_admin?).and_return false
      end
      it 'should not delete tag from all records' do
        Record.should_not_receive(:delete_tag)
        do_delete
      end
    end
  end

  describe "when posted to toggle admin action" do
    def do_post
      request.env["HTTP_REFERER"] = '/previous/url'
      post :toggle_admin
    end
    it 'should be successful' do
      do_post
      response.should be_redirect
    end
    it "should redirect to root" do
      do_post
      response.should redirect_to('http://test.host/previous/url')
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
