class RecordsController < ApplicationController
  # GET /record
  # GET /record.xml
  def index
    @records = Record.find(:all)

    respond_to do |format|
      format.html # index.haml
      format.xml  { render :xml => @records }
    end
  end

  # GET /record/1
  # GET /record/1.xml
  def show
    @record = Record.find(params[:id])

    respond_to do |format|
      format.html # show.haml
      format.xml  { render :xml => @record }
    end
  end

  # GET /record/new
  # GET /record/new.xml
  def new
    @record = Record.new

    respond_to do |format|
      format.html # new.haml
      format.xml  { render :xml => @record }
    end
  end

  # GET /record/1/edit
  def edit
    @record = Record.find(params[:id])
  end

  # POST /record
  # POST /record.xml
  def create
    @record = Record.new(params[:record])

    respond_to do |format|
      if @record.save
        flash[:notice] = 'Record was successfully created.'
        format.html { redirect_to(record_path(@record)) }
        format.xml  { render :xml => @record, :status => :created, :location => @record }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /record/1
  # PUT /record/1.xml
  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        flash[:notice] = 'Record was successfully updated.'
        format.html { redirect_to(record_path(@record)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @record.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
    end
  end
end
