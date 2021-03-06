class RecordsController < ApplicationController

  before_filter :respond_not_found_if_record_doesnt_exist, :only => ['edit', 'show', 'update', 'destroy']
  before_filter :ensure_record_url_is_current, :only => ['edit', 'show']

  before_filter :search, :only => 'show'

  require 'json'

  in_place_edit_for :record, :title
  in_place_edit_for :record, :first_name
  in_place_edit_for :record, :middle_name
  in_place_edit_for :record, :last_name
  in_place_edit_for :record, :suffix
  in_place_edit_for :record, :notes

  before_filter :authorize, :except => [:toggle_admin, :search, :index, :show, :get_record_notes, :status, :tag]
  before_filter :find_record, :only => [:show, :edit, :update, :get_record_notes, :set_record_notes]

  uses_tiny_mce(:options => {
      :theme => 'advanced',
      :mode => "textareas",
      :height => 500,
      :content_css => "/stylesheets/default.css",
      :remove_script_host => true,
      :theme_advanced_toolbar_location => "top",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_buttons1 => %w[spellchecker],
      :theme_advanced_buttons2 => %w[],
      :theme_advanced_buttons3 => %w[],
      :editor_selector => 'mceEditor',
      :spellchecker_rpc_url => "/records/spellcheck",
      :spellchecker_languages => "+English=en",
      :plugins => %w[ contextmenu paste spellchecker]
    }, :only => [:edit, :new])

  def spellcheck
    raw = request.env['RAW_POST_DATA']
    req = JSON.parse(raw)
    lang = req["params"][0]
    if req["method"] == 'checkWords'
      text_to_check = req["params"][1].join(" ")
    else
      text_to_check = req["params"][1]
    end
    suggestions = check_spelling_new(text_to_check, req["method"], lang)
    render :json => {"id" => nil, "result" => suggestions, "error" => nil}.to_json
    return
  end

  def toggle_admin
    if request.post?
      session[:is_admin] = !session[:is_admin]
    end
    redirect_to :back
  end

  def tag
    if params[:id]
      @tag = decode_tag(params[:id])
      @words_to_highlight = [@tag]
      @records = Record.find_with_tag @tag
    end
    render :template=>'records/tag_results'
  end

  def status
    if params[:id]
      @status = decode_tag(params[:id])
      @words_to_highlight = [@status]
      @records = Record.find_with_status @status
    end
    render :template=>'records/status_results'
  end

  def search_info
  end

  def search
    if params[:q]
      redirect_to_search_result_url
    elsif params[:query]
      page = params['page'] || 1
      @term = params[:query]

      @records = WillPaginate::Collection.create(page, Record.per_page) do |pager|
        records, @words_to_highlight, matches_estimated, @spelling_correction = Record.search(@term, pager.offset)
        pager.replace(records)
        pager.total_entries = matches_estimated
        @matches_estimated = matches_estimated
      end

      render :template=>'records/search_results'
    else
      @tags = Record.common_tags
      @statuses = Record.common_statuses
      if is_admin?
        @records_needing_check = Record.all_needing_check
        @records_recently_edited = Record.recently_edited
      end
    end
  end

  def recent_edits
    page = params['page'] || 1
    @records = WillPaginate::Collection.create(page, Record.per_page) do |pager|
      records = Record.find(:all, :offset=>pager.offset, :limit => Record.per_page, :order => 'updated_at desc')
      pager.replace(records)
      pager.total_entries = Record.count
    end
  end

  # GET /record
  def index
    page = params['page'] || 1

    @records = WillPaginate::Collection.create(page, Record.per_page) do |pager|
      records = Record.find(:all, :offset=>pager.offset, :limit => Record.per_page, :order => 'name asc')
      # inject the result array into the paginated collection:
      pager.replace(records)
      # set total of estimated matches
      pager.total_entries = Record.count
    end

    respond_to do |format|
      format.html # index.haml
      format.atom
    end
  end

  # GET /record/1
  def show
    @tags = @record.tag_list
    @statuses = @record.status_list

    @similar_records = @record.similar_records

    respond_to do |format|
      format.html # show.haml
    end
  end

  # GET /record/new
  def new
    @record = Record.new

    respond_to do |format|
      format.html # new.haml
    end
  end

  # GET /record/1/edit
  def edit
  end

  # POST /record
  def create
    record_params = params[:record]
    record_params[:notes] = unhtml(record_params[:notes]) if record_params
    @record = Record.new(params[:record])

    respond_to do |format|
      if @record.save
        flash[:notice] = 'Record was successfully created.'
        format.html { redirect_to(record_path(@record)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /record/1
  def update
    respond_to do |format|
      record_params = params[:record]
      record_params[:notes] = unhtml(record_params[:notes]) if record_params
      if @record.update_attributes(record_params)
        flash[:notice] = 'Record was successfully updated.'
        format.html { redirect_to(record_path(@record)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /record/1
  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to(records_url) }
    end
  end

  # Used by in place editor to set unformatted notes
  def set_record_notes
    notes = params[:value]
    @record.notes = notes
    @record.save!
    render :layout => false, :inline => "<%= html_formatted_notes(@record) %>"
  end

  # Used by in place editor to get unformatted notes
  def get_record_notes
    @notes = @record.notes
    render :layout => false, :inline => "<%= @notes %>"
  end

  def rename_tag
    if is_admin? && request.post? && !params['old_tag'].blank? && !params['new_tag'].blank?
      old_tag = decode_tag(params['old_tag'])
      new_tag = decode_tag(params['new_tag'])
      records = Record.rename_tag old_tag, new_tag
      flash[:notice] = "Renaming tag to '#{new_tag}' successful, #{records.size} record#{records.size>1 ? 's':''} changed."
      redirect_to :action => 'tag', :id => new_tag
    else
      render :text => ''
    end
  end

  def add_tag
    if is_admin? && request.post? && !params['tag'].blank? && !params['query'].blank?
      tag = decode_tag(params['tag'])
      query = params['query']
      records = Record.tag_query_results(query, tag)
      flash[:notice] = "Adding '#{tag}' tag successful, #{records.size} record#{records.size>1 ? 's':''} changed."
      redirect_to :action => 'search', :query => query
    else
      render :text => ''
    end
  end

  def delete_tag
    if is_admin? && request.delete? && !params['id'].blank?
      tag = decode_tag(params['id'])
      Record.delete_tag tag
      flash[:notice] = "Deletion of '#{tag}' tags successful."
      redirect_to :action => 'tag', :id => params['id']
    else
      render :text => ''
    end
  end

  private

    def respond_not_found_if_record_doesnt_exist
      begin
        @record = Record.find(params[:id])
      rescue
        render_not_found
      end
    end

    def ensure_record_url_is_current
      redirect_to @record, :status => :moved_permanently if @record.has_better_id?
    end

    def redirect_to_search_result_url
      if request.post? && !params[:q].blank?
        query = params[:q].gsub('.','')
        redirect_to :action => 'search', :query => query
        return false
      else
        redirect_to :action => 'search'
      end
    end

    def unhtml text
      if false
        unless text.blank?
          text.gsub!("\r",'')
          text.gsub!("\n",'')
          text.gsub!('<p><br />','<p>')
          text.gsub!('<br />',"\n")
          text.gsub!("</p><p>","\n\n")
          text.gsub!(/<[^>]+>/,'')
          text.gsub!('&lt;','<')
          text.gsub!('&gt;','>')
          text.gsub!('&nbsp;',' ')
          text.gsub!('&amp;','&')
          text.strip!
        end
      end
      text
    end

    def decode_tag tag
      tag.gsub('_',' ')
    end

    def find_record
      @record = Record.find(params[:id])
    end

    def authorize
      unless is_admin?
        redirect_to(:action => "search" )
      end
    end

    def check_spelling_new(spell_check_text, command, lang)
      json_response_values = Array.new
      spell_check_response = `echo "#{spell_check_text}" | aspell -a -l #{lang}`
      if (spell_check_response != '')
        spelling_errors = spell_check_response.split(' ').slice(1..-1)
        if (command == 'checkWords')
          i = 0
          while i < spelling_errors.length
            spelling_errors[i].strip!
            if (spelling_errors[i].to_s.index('&') == 0)
              match_data = spelling_errors[i + 1]
              json_response_values << match_data
            end
            i += 1
          end
        elsif (command == 'getSuggestions')
          arr = spell_check_response.split(':')
          suggestion_string = arr[1]
          suggestions = suggestion_string.split(',')
          for suggestion in suggestions
            suggestion.strip!
            json_response_values << suggestion
          end
        end
      end
      return json_response_values
    end
end
