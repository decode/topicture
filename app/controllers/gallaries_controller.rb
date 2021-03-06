class GallariesController < ApplicationController
  layout 'site'

  before_filter :only => 'show' do |controller|
    controller.has_right?(controller.params[:id])
  end

  # GET /gallaries
  # GET /gallaries.xml
  def index
    unless params[:user_id].nil?
      user = User.find params[:user_id]
      @gallaries = user.gallaries.find :all
    else
      @gallaries = Gallary.find :all, :conditions => 'ispublic = true', :order => 'updated_at DESC'
    end
    session[:gallary_password] = nil
    session[:gallary] = nil
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
        #format.html { redirect_to(@gallary) }
        format.html { redirect_to :back }
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

  def check_pass
    #gallary = Gallary.find params[:gallary][:id]  
    gallary = Gallary.find params[:passbox][:id]  

    respond_to do |format|
      if gallary.password == params[:gallary][:password].chomp
        session[:gallary] = gallary.id
        session[:gallary_password] = gallary.password
        format.html { redirect_to :action => "show", :id => gallary }
      else
        format.html {
          flash[:error] = 'Wrong password'
          redirect_to :action => 'index' 
        }
        format.js do
          render do |page|
            page.show 'passbox'
          end
        end
      end
    end
  end
  
  def has_right?(gallary_id)
    @gallary = Gallary.find gallary_id
    unless @gallary.password.nil? || @gallary.password.length <= 0
      unless (session[:gallary_password] == @gallary.password) && (session[:gallary] == @gallary.id)
        flash[:error] = "Wrong password!"
        redirect_to :action => "index"
        return
      end
    end
    if @gallary.isfriend == true
      unless @gallary.user == current_user || @gallary.user.friends.include?(current_user)
        flash[:error] = "You have no permission to view this gallary"
        redirect_to :action => "index"
      end
    end
  end

end
