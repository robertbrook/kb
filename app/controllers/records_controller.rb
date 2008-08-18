class RecordsController < ApplicationController

  in_place_edit_for :record, :title
  in_place_edit_for :record, :first_name
  in_place_edit_for :record, :middle_name
  in_place_edit_for :record, :last_name
  in_place_edit_for :record, :suffix
  in_place_edit_for :record, :notes

  before_filter :find_record, :only => [:show, :edit, :update, :get_record_notes, :set_record_notes]

  def find_record
    @record = Record.find(params[:id])
  end

  # GET /record
  # GET /record.xml
  def index
    @records = Record.find(:all).sort
    respond_to do |format|
      format.html # index.haml
    end
  end

  # GET /record/1
  # GET /record/1.xml
  def show
    respond_to do |format|
      format.html # show.haml
    end
  end

  # GET /record/new
  # GET /record/new.xml
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
  # POST /record.xml
  def create
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
  # PUT /record/1.xml
  def update
    respond_to do |format|
      if @record.update_attributes(params[:record])
        flash[:notice] = 'Record was successfully updated.'
        format.html { redirect_to(record_path(@record)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /record/1
  # DELETE /record/1.xml
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
    @html_formatted_notes = @record.html_formatted_notes
    render :layout => false, :inline => "<%= @html_formatted_notes %>"
  end

  # Used by in place editor to get unformatted notes
  def get_record_notes
    @notes = @record.notes
    render :layout => false, :inline => "<%= @notes %>"
  end

end
