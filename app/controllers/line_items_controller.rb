# -*- coding: utf-8 -*-
class LineItemsController < ApplicationController
  
  authorize_resource :only => :index
  # GET /line_items
  # GET /line_items.xml
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @line_items }
    end
  end

def change_quantity
  @cart = current_cart
  @line_item = LineItem.find(params[:id])
  if  params[:quantity].to_i > 0
    @line_item.quantity = params[:quantity]
    if !@line_item.save
            format.html { redirect_to root_path }
            format.xml  { render :xml => @line_item.errors,
            :status => :unprocessable_entity }
    else
      respond_to do |format|
        format.html { render :layout=>false }     
        format.js
      end
    end
  else
    @line_item.destroy
    respond_to do |format|
        format.html { render :layout=>false }     
        format.js
    end
  end
end

  # GET /line_items/1
  # GET /line_items/1.xml
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.xml
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.xml
  def create
    @cart = current_cart
    if (!params[:product_id])
      @templates = Template.find_all_by_user_id(current_user.id)
      @templates.each do |template|
        product = Product.find(template.product_id)
        @line_item = @cart.add_product(product.id)
        if !@line_item.save
          format.html { render :action => "new" }
          format.xml  { render :xml => @line_item.errors,
          :status => :unprocessable_entity }
        end
      end
    else    
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
      if !@line_item.save
          format.html { render :action => "new" }
          format.xml  { render :xml => @line_item.errors,
          :status => :unprocessable_entity }
      end
    end
    respond_to do |format|
      
        format.html { redirect_to(root_path) }
        format.js   { @current_item = @line_item }
        format.xml  { render :xml => @line_item,
          :status => :created, :location => @line_item }
        
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.xml
  def update
#raise "SomeError message ..." 
    if (params[:id] and params[:quantity])
      @line_item = LineItem.find(params[:id])
      @line_item.quantity = params[:quantity]
    else
      @line_item = LineItem.find(params[:id])
    end
    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        #'Line item was successfully updated.'
        format.html { redirect_to(store_view_cart_path, :notice => 'Позиция была успешно изменена.') }
        format.js {render :layout=>false}  
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js {render :layout=>false}  
        format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
end
