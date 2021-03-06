# -*- coding: utf-8 -*-
class ProductsController < ApplicationController
  load_and_authorize_resource :except => [:index, :file_upload]
#  authorize_resource
  # GET /products
  # GET /products.xml
  def index
      @products = Product.all.paginate(:per_page => 10, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
    
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    #@product = Product.find(params[:id])
    #authorize! :show, @product
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    #@product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    #@product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    #@product = Product.new(params[:product])
#raise "safety_care group missing!"
    case params[:commit]
    when 'file_down'
    require 'fileutils'
    require 'spreadsheet'

    tmp = params[:excel_file_upload][:excel_file].tempfile
    Spreadsheet.client_encoding = 'UTF-8'
    file = File.join("public", params[:excel_file_upload][:excel_file].original_filename) or raise "cannot join file"
    FileUtils.cp tmp.path, file
    book = Spreadsheet.open file
    sheet = book.worksheet 0
#raise "safety_care group missing!"
    
#=begin
    if params[:excel_file_upload][:replace] = 1
      Product.delete_all
      sheet.each do |row| 
        ff = File.join(Rails.root, "/public/images/wqe/pic0404/#{row[3].to_s.mb_chars.downcase}.jpg")
        if File.exist?(ff)
          image_file = File.open(ff) 
          Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11], :image => image_file)
        else
          Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11])
        end
      end
    elsif  params[:excel_file_upload][:replace] = 2
      sheet.each do |row| 
        if @product = Product.find_by_model(row[3].to_s)
          ff = File.join(Rails.root, "/public/images/wqe/pic0404/#{row[3].to_s}.jpg")
          if File.exist?(ff)
            image_file = File.open(ff)
            @product.update_attributes(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11], :image => image_file)
          else
            @product.update_attributes(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11])
          end
        else
          ff = File.join(Rails.root, "/public/images/wqe/pic0404/#{row[3].to_s}.jpg")
          if File.exist?(ff)
            image_file = File.open(ff)
            Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11], :image => image_file)
          else
            Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11])
          end
        end
      end
    end
#=end
    FileUtils.rm file
    @products = Product.all.paginate(:per_page => 10, :page => params[:page])
redirect_to products_url
    else
      respond_to do |format|
        if @product.save
          format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
          format.xml  { render :xml => @product, :status => :created, :location => @product }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    #@product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    #@product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def who_bought
    #@product = Product.find(params[:id])
    respond_to do |format|
      format.atom
      format.xml { render :xml => @product }
    end
  end

  def file_upload
    tmp = params[:excel_file_upload][:excel_file].tempfile
    require 'fileutils'
    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'
    
    file = File.join("public", params[:excel_file_upload][:excel_file].original_filename)
    File.cp tmp.path, file
    book = Spreadsheet.open file
    sheet = book.worksheet 0
raise "safety_care group missing!"
    flash[:error] = "You cant work: :category=>#{row[1].to_s}, :producer=>#{row[2].to_s}, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11],"
=begin
    if params[:excel_file_upload][:replace] = 1
      Product.delete_all
      sheet.each do |row| 
        image_file = File.open(File.join(Rails.root, '/public/images/wqe/pic0404/BCI-11Bk.jpg'))
        if image_file
          Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11], :image => image_file)
        else
          Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11])
        end
      end
    elsif  params[:excel_file_upload][:replace] = 2
      sheet.each do |row| 
        if @product = Product.find_by_model(row[3].to_s)        
          if image_file = File.open(File.join(Rails.root, '/public/images/wqe/pic0404/BCI-11Bk.jpg'))
            @product.update_attributes(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11], :image => image_file)
          else
            @product.update_attributes(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11])
          end
        else
          if image_file = File.open(File.join(Rails.root, '/public/images/wqe/pic0404/BCI-11Bk.jpg'))
            Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11], :image => image_file)
          else
            Product.create(:category=>row[1].to_s, :producer=>row[2].to_s, :model=>row[3].to_s, :title=>row[4].to_s, :print_tech=>row[5].to_s, :color=>row[6].to_s, :compatibility=>row[7].to_s, :capacity=>row[8].to_s, :weight=>row[9], :description=>row[10].to_s, :price => row[11])
          end
        end
      end
    end
=end


    FileUtils.rm file
  end
end
