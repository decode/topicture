class GallariesController < ApplicationController
  layout 'site'

  # GET /gallaries
  # GET /gallaries.xml
  def index
    unless params[:user_id].nil?
      user = User.find params[:user_id]
      @gallaries = user.gallaries.find :all
    else
      @gallaries = Gallary.find :all, :conditions => 'ispublic = true', :order => 'updated_at DESC'
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gallaries }
    end
  end

  # GET /gallaries/1
  # GET /gallaries/1.xml
  def show
    @gallary = Gallary.find(params[:id])
    @attachments = Attachment.paginate :all, :conditions => ['gallary_id = ?', @gallary.id], :page => params[:page], :per_page => 12
    @permit = @gallary.user == current_user ? true : false
    session[:return_to] = gallary_path(@gallary)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallary }
    end
  end

  # GET /gallaries/new
  # GET /gallaries/new.xml
  def new
    @gallary = Gallary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallary }
    end
  end

  # GET /gallaries/1/edit
  def edit
    @gallary = Gallary.find(params[:id])
  end

  # POST /gallaries
  # POST /gallaries.xml
  def create
    @gallary = Gallary.new(params[:gallary])
    @gallary.user = current_user
    respond_to do |format|
      if @gallary.save
        flash[:success] = 'Gallary was successfully created.'
        format.html { redirect_to(@gallary) }
        format.xml  { render :xml => @gallary, :status => :created, :location => @gallary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gallaries/1
  # PUT /gallaries/1.xml
  def update
    @gallary = Gallary.find(params[:id])

    respond_to do |format|
      if @gallary.update_attributes(params[:gallary])
        flash[:success] = 'Gallary was successfully updated.'
        format.html { redirect_to(@gallary) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gallaries/1
  # DELETE /gallaries/1.xml
  def destroy
    @gallary = Gallary.find(params[:id])
    @gallary.destroy

    respond_to do |format|
      format.html { redirect_to(gallaries_url) }
      format.xml  { head :ok }
    end
  end
  
  def view
    @user = User.find params[:id]   
    @gallaries = Gallary.paginate :all, :conditions => ['user_id=? and ispublic=true', @user.id], :order => 'created_at DESC', :page => params[:page], :per_page => 10
  rescue
    redirect_to gallaries_url
  end
  
end
