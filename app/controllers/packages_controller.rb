require 'net/http'
require 'uri'
require 'json'

class PackagesController < ApplicationController
  before_action :set_package, only: [:show]
  
  def index
    @packages = Package.all.order(created_at: :desc)
  
    # Filter by tracking number if present
    if params[:tracking_number].present?
      @packages = @packages.where("tracking_number LIKE ?", "%#{params[:tracking_number]}%")
    end
  
    # Filter by date range if both start_date and end_date are present
    if params[:start_date].present? && params[:end_date].present?
      begin
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        @packages = @packages.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      rescue ArgumentError
        flash[:alert] = "Invalid date range provided."
      end
    end
  end
  

  def new
    @package = Package.new
    @users = User.all
  
    if params[:package]
      category_id = params[:package][:category_id]
      weight = params[:package][:weight].to_f
      amount = params[:package][:amount].to_f
  
      # Fetch category data
      category = Category.find_by(id: category_id)
  
      if category
        if category.name.downcase == "cash"
          cost = amount * (category.fee_percentage / 100.0)
          cost = [cost, category.minimum_cost].max
          @package.assign_attributes(category: category, amount: amount, cost: cost)
        else
        # Assign attributes including category and cost
        cost = weight * category.base_price
        cost = [cost, category.minimum_cost].max # Apply minimum cost
        @package.assign_attributes(category: category, weight: weight, cost: cost)
        end
      else
        flash.now[:alert] = "Category not found."
      end
    end
  end
  

  def create
    # Extract new sender parameters from package_params
    new_sender_params = {
      name: params[:package].delete(:new_sender_name),
      id_number: params[:package].delete(:new_sender_id_number),
      phone: params[:package].delete(:new_sender_phone),
      address: params[:package].delete(:new_sender_address)
    }

    new_receiver_params = {
      name: params[:package].delete(:new_receiver_name),
      id_number: params[:package].delete(:new_receiver_id_number),
      phone: params[:package].delete(:new_receiver_phone),
      address: params[:package].delete(:new_receiver_address)
    }

    # Check if we need to create a new sender
    if new_sender_params[:name].present?
      # Create a new user with the provided new sender details
      new_sender = User.find_or_create_by(id_number: new_sender_params[:id_number]) do |user|
        user.name = new_sender_params[:name]
        user.phone = new_sender_params[:phone]
        user.address = new_sender_params[:address]
      end

      # Check if user creation succeeded and assign the new sender's ID
      if new_sender.persisted?
        params[:package][:sender_id] = new_sender.id
      else
        flash.now[:alert] = "There was an error creating the sender."
        render :new and return
      end
    end

    if new_receiver_params[:name].present?
      new_receiver = User.find_or_create_by(id_number: new_receiver_params[:id_number]) do |user|
        user.name = new_receiver_params[:name]
        user.phone = new_receiver_params[:phone]
        user.address = new_receiver_params[:address]
      end

      if new_receiver.persisted?
        params[:package][:receiver_id] = new_receiver.id
      else
        flash.now[:alert] = "There was an error creating the receiver."
        render :new and return
      end
    end

    @package = Package.new(package_params)
    @package.category = Category.find_by(id: package_params[:category_id])
  
    if @package.category
      if @package.category.name.downcase == "cash"
        @package.amount = package_params[:amount]
        @package.cost = @package.calculate_cost
        Rails.logger.info("Cost calculated for cash package" + @package.cost.to_s)
      else
       @package.cost = @package.total_cost # Ensure cost calculation is run with category data
       Rails.logger.info("Calculating cost for non-cash package")
      end
    end




    

  
    if @package.save
      collection_point = @package.destination_city.collection_point_address
      sms_serviceone = InfobipSmsService.new
      message = "Your package is on its way! Tracking Number: #{@package.tracking_number}. " \
                  "Use your assigned PIN #{@package.collection_pin} to collect it at #{collection_point}."
      
      sender_message = "Your package has been successfully sent. Tracking Number: #{@package.tracking_number}."

       response = sms_serviceone.send_sms("+#{@package.receiver.phone}", message)

      sms_serviceone.send_sms("+#{@package.sender.phone}", sender_message)

      if response['messages'] && response['messages'].first['status']['groupName'] == 'PENDING'
        Rails.logger.info("SMS sent successfully!")
      else
        Rails.logger.error("SMS sending failed: #{response}")
      end

      flash[:notice] = "Package created and notifications sent."
      redirect_to @package
    else
      flash.now[:alert] = "There was an error creating the package."
      Rails.logger.error @package.errors.full_messages
      render :new
    end
  end

  def show
  end

  def process_collection
    @package = Package.find_by(tracking_number: params[:tracking_number])

    message = "Your package with Tracking Number: #{@package.tracking_number} has been successfully collected."

    sms_serviceone = InfobipSmsService.new
    response = sms_serviceone.send_sms("+#{@package.receiver.phone}", message)

  
      if params[:collection_pin] == @package.collection_pin
        @package.update(status: "collected")
        sms_serviceone.send_sms("+#{@package.receiver.phone}", message)
        sms_serviceone.send_sms("+#{@package.sender.phone}", message)
  
        if response['messages'] && response['messages'].first['status']['groupName'] == 'PENDING'
          Rails.logger.info("SMS sent successfully!")
        else
          Rails.logger.error("SMS sending failed: #{response}")
        end

        redirect_to package_path(@package), notice: "Package successfully collected!"
      else
        flash[:alert] = "Invalid collection PIN. Please try again."
        redirect_to package_path(@package)

      end
  end

  def update_payment_status
    @package = Package.find(params[:id])
  
    if @package.update(payment_status: params[:package][:payment_status])
      redirect_to @package, notice: "Payment status successfully updated."
    else
      redirect_to @package, alert: "Failed to update payment status."
    end
  end

  

  private

  def set_package
    @package = Package.find(params[:id])
  end

  def package_params
    params.require(:package).permit(
      :category_id, :weight, :cost, :sender_id, :receiver_id, :status, :payment_method,
       :payment_status, :collection_pin, :tracking_number, :origin_city_id, :destination_city_id, :amount)
  end
  
end

# message = "Your package with tracking Number #{package.tracking_number} has been successfully collected."

