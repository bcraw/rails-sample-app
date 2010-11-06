class JobPostsController < ApplicationController
  # GET /job_posts
  # GET /job_posts.xml
  def index


   #todo: move this logic into the jobpost model

   do_srch = false
    qry = ""
    qryvals = []

    srchTitle = params[:search_title]
    srchSalMin = params[:search_salmin]
    srchSalMax = params[:search_salmax]
    srchZip = params[:search_zip]

    unless srchTitle.to_s.empty?
      qry = 'title like ?'
      qryvals << "%#{params[:search_title]}%"
      do_srch = true
    end

    if ! srchSalMin.to_s.empty? || ! srchSalMax.to_s.empty?
      if ! srchSalMin.to_s.empty? && ! srchSalMax.to_s.empty?
        if do_srch
          qry = qry + ' and salary between ? and ?'
        else
          qry = 'salary between ? and ?'
        end
        qryvals << "#{params[:search_salmin]}" <<  "#{params[:search_salmax]}"
        do_srch = true
      elsif ! srchSalMin.to_s.empty?
        if do_srch
          qry = qry + ' and salary >= ?'
        else
          qry = 'salary >= ?'
        end
        qryvals << "#{params[:search_salmin]}"
        do_srch = true
      else
        if do_srch
          qry = qry + ' and salary <= ?'
        else
          qry = 'salary <= ?'
        end
        qryvals << "#{params[:search_salmax]}"
        do_srch = true
      end
    end

    unless srchZip.to_s.empty?
      if do_srch
         qry = qry + ' and company_id in(select id from companies where zip = ?)'
      else
        qry = 'company_id in(select id from companies where zip = ?)'
      end
      qryvals << "#{params[:search_zip]}"
      do_srch = true
    end

    if do_srch
      @job_posts = JobPost.find(:all, :conditions => [qry, *qryvals])
    else
      @job_posts = JobPost.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @job_posts }
    end
  end

  # GET /job_posts/1
  # GET /job_posts/1.xml
  def show
    @job_post = JobPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @job_post }
    end
  end

  # GET /job_posts/new
  # GET /job_posts/new.xml
  def new
    @job_post = JobPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @job_post }
    end
  end

  # GET /job_posts/1/edit
  def edit
    @job_post = JobPost.find(params[:id])
  end

  # POST /job_posts
  # POST /job_posts.xml
  def create
    @job_post = JobPost.new(params[:job_post])

    respond_to do |format|
      if @job_post.save
        format.html { redirect_to(@job_post, :notice => 'Job post was successfully created.') }
        format.xml  { render :xml => @job_post, :status => :created, :location => @job_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /job_posts/1
  # PUT /job_posts/1.xml
  def update
    @job_post = JobPost.find(params[:id])

    respond_to do |format|
      if @job_post.update_attributes(params[:job_post])
        format.html { redirect_to(@job_post, :notice => 'Job post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /job_posts/1
  # DELETE /job_posts/1.xml
  def destroy
    @job_post = JobPost.find(params[:id])
    @job_post.destroy

    respond_to do |format|
      format.html { redirect_to(job_posts_url) }
      format.xml  { head :ok }
    end
  end
end

