
class CoreUserManagementController < ApplicationController

  before_filter :check_user, :except => [:login, :authenticate, :verify]

  before_filter :check_location, :except => [:login, :authenticate, :logout, :verify, :location, :location_update]

  def login

    # Track final destination
    file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.login.yml"

    if !params[:ext].nil?

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    host.path.login: #{params[:src] rescue ""}#{
        (!request.referrer.match(/user\_id|location\_id/) ? request.referrer : "") }")

      f.close

    end

    @destination = nil

    if File.exists?(file)

      @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

    end

  end

  def authenticate
    user = CoreUser.authenticate(params[:login], params[:password]) rescue nil

    if user.status_value.nil?
      flash[:error] = "Unauthorised user!"
      redirect_to request.referrer and return
    elsif user.status_value.downcase != "active"
      flash[:error] = "Unauthorised user!"
      redirect_to request.referrer and return
    end

    if user.nil?
      flash[:error] = "Wrong username or password!"
      redirect_to request.referrer and return
    end

    CoreUserProperty.find_by_user_id_and_property(user.id, "Token").delete rescue nil

    CoreUserProperty.create(
      :user_id => user.id,
      :property => "Token",
      :property_value => CoreUser.random_string(16)
    )

    redirect_to "/location?user_id=#{user.id}" and return

  end

  def new_user
    @roles = CoreRole.find(:all).collect{|r|r.role}
  end

  def create_user

    existing = CoreUser.find_by_username(params[:login]) rescue nil

    if !existing.nil?
      flash[:error] = "Username already taken!"
      redirect_to "/new_user?user_id=#{@user.id}&first_name=#{params[:first_name]
          }&last_name=#{params[:last_name]}&gender=#{params[:gender]}#{
      (!params[:src].nil? ? "&src=#{params[:src]}" : "")}" and return
    end

    user = CoreUser.create(
      :username => params[:login],
      :password => params[:password],
      :creator => params[:user_id],
      :date_created => Date.today,
      :uuid => ActiveRecord::Base.connection.select_one("SELECT UUID() as uuid")['uuid']
    )

    CoreUserProperty.create(
      :user_id => user.id,
      :property => "First Name",
      :property_value => (params[:first_name] rescue nil)
    )

    CoreUserProperty.create(
      :user_id => user.id,
      :property => "Last Name",
      :property_value => (params[:last_name] rescue nil)
    )

    CoreUserProperty.create(
      :user_id => user.id,
      :property => "Gender",
      :property_value => (params[:gender] rescue nil)
    )

    CoreUserProperty.create(
      :user_id => user.id,
      :property => "Status",
      :property_value => "PENDING"
    )

    params[:roles].each do |role|
        
      CoreUserRole.create(
        :user_id => user.id,
        :role => role
      )
        
    end

    redirect_to "/user_list?user_id=#{(params[:id] || params[:user_id])}&location_id=#{
    params[:location_id]}#{(!params[:src].nil? ? "&src=#{params[:src]}" : "")}" and return
  end

  def select_user_task

    # Track final destination
    file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.login.yml"

    if !params[:ext].nil?

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    host.path.login: #{params[:src] rescue ""}#{request.referrer}")

      f.close

    end

    @destination = "/logout/#{@user.id}"

    if File.exists?(file)

      @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

    end

  end

  def user_list

    @destination = "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}"

    if !params[:src].nil?
      # Track final destination
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    host.path.login: #{params[:src] rescue ""}?user_id=#{@user.id}")

      f.close

      if File.exists?(file)

        @destination = "http://" + YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

      end
    end

    @users = CoreUser.find(:all).collect { |user|
      [
        user.name,
        user.username,
        user.gender,
        user.user_roles.collect{|r|
          r.role
        },
        (user.status.property_value rescue ""),
        user.id
      ]
    }

    if @user.status_value.to_s.downcase != "pending" and @user.status_value.to_s.downcase != "blocked"
      
      @can_edit = true

    else

      @can_edit = false

    end

    redirect_to "/login" and return if @user.nil?

  end

  def edit_user_status

    if params[:target_id].nil?
      flash[:error] = "Missing User ID!"
      redirect_to request.referrer and return
    end

    @target = CoreUser.find(params[:target_id]) rescue nil

  end

  def update_user_status

    property = CoreUserProperty.find_by_property_and_user_id("Status", params[:target_id]) rescue nil

    if property.nil?
      CoreUserProperty.create(
        :user_id => params[:target_id],
        :property => "Status",
        :property_value => (params[:status] rescue nil)
      )
    else
      property.update_attributes(:property_value => params[:status])
    end

    flash[:notice] = "Status changed to #{params[:status].upcase}"
    redirect_to "/user_list?user_id=#{@user.id}&location_id=#{
    params[:location_id]}#{(!params[:src].nil? ? "&src=#{params[:src]}" : "")}" and return
  end

  def edit_roles

    @target = CoreUser.find(params[:target_id]) rescue nil
    
    current_roles = @target.user_roles.collect{|r| r.role}

    @roles = CoreRole.find(:all).collect{|r|r.role} - current_roles
    
  end

  def add_user_roles

    @target = CoreUser.find(params[:target_id]) rescue nil

    params[:roles].each do |role|

      CoreUserRole.create(
        :user_id => @target.id,
        :role => role
      )
    end

    redirect_to "/user_list?user_id=#{@user.id}&location_id=#{
    params[:location_id]}#{(!params[:src].nil? ? "&src=#{params[:src]}" : "")}" and return
  end

  def void_role

    @target = CoreUser.find(params[:target_id]) rescue nil

    CoreUserRole.find_by_user_id_and_role(@target.id, params[:role]).delete rescue nil

    redirect_to "/user_list?user_id=#{@user.id}&location_id=#{params[:location_id]
}#{(!params[:src].nil? ? "&src=#{params[:src]}" : "")}" and return
  end

  def edit_user

    if !params[:src].nil?
      # Track final destination
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    host.path.login: #{params[:src] rescue ""}?user_id=#{@user.id}")

      f.close

      @destination = nil

      if File.exists?(file)

        @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

      end
    end

    @first_name = CoreUserProperty.find_by_property_and_user_id("First Name", params[:user_id]).property_value rescue nil

    @last_name = CoreUserProperty.find_by_property_and_user_id("Last Name", params[:user_id]).property_value rescue nil

    @gender = CoreUserProperty.find_by_property_and_user_id("Gender", params[:user_id]).property_value rescue nil

  end

  def update_user

    fn_property = CoreUserProperty.find_by_property_and_user_id("First Name", params[:user_id]) rescue nil

    if fn_property.nil?
      CoreUserProperty.create(
        :user_id => params[:user_id],
        :property => "First Name",
        :property_value => (params[:first_name] rescue nil)
      )
    else
      fn_property.update_attributes(:property_value => params[:first_name])
    end

    ln_property = CoreUserProperty.find_by_property_and_user_id("Last Name", params[:user_id]) rescue nil

    if ln_property.nil?
      CoreUserProperty.create(
        :user_id => params[:user_id],
        :property => "Last Name",
        :property_value => (params[:last_name] rescue nil)
      )
    else
      ln_property.update_attributes(:property_value => params[:last_name])
    end

    gn_property = CoreUserProperty.find_by_property_and_user_id("Gender", params[:user_id]) rescue nil

    if gn_property.nil?
      CoreUserProperty.create(
        :user_id => params[:user_id],
        :property => "Gender",
        :property_value => (params[:gender] rescue nil)
      )
    else
      gn_property.update_attributes(:property_value => params[:gender])
    end

    if !params[:src].nil?
      
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

      @destination = nil

      if File.exists?(file)

        @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

      else

        flash[:notice] = "Demographics updated!"

        redirect_to "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return

      end
      
      if !@destination.nil?
        q = (@destination.match(/\?/))
        u = (@destination.match(/user_id=(\d+)/))

        if u

          @destination = @destination.gsub(/user_id=(\d+)/, "user_id=#{@user.id}&location_id=#{params[:location_id]}")

          redirect_to "http://#{@destination}" and return

        else

          redirect_to "http://#{@destination}#{(!q ? "?" : "")}user_id=#{
          @user.id}&location_id=#{params[:location_id]}" and return

        end

      else

        flash[:notice] = "Demographics updated!"

        redirect_to "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return
        
      end

    else

      flash[:notice] = "Demographics updated!"

      redirect_to "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return

    end

  end

  def edit_password

    if !params[:src].nil?
      # Track final destination
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    host.path.login: #{params[:src] rescue ""}?user_id=#{@user.id}")

      f.close

      @destination = nil

      if File.exists?(file)

        @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

      end
    end

  end

  def update_password
    old = CoreUser.authenticate(@user.username, params[:old_password]) # rescue nil

    if old.nil?
      flash[:error] = "Invalid current password!"

      redirect_to request.referrer and return
    end

    user = CoreUser.find(params[:user_id]) #rescue nil

    if !user.nil?
      
      user.update_attributes(:password => params[:password])
      
      flash[:notice] = "Password updated!"
    end

    # redirect_to "/select_user_task?user_id=#{params[:user_id]}" and return

    if !params[:src].nil?

      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

      @destination = nil

      if File.exists?(file)

        @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

      else

        flash[:notice] = "Password updated!"

        redirect_to "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return

      end

      if !@destination.nil?
        q = (@destination.match(/\?/))
        u = (@destination.match(/user_id=(\d+)/))

        if u

          @destination = @destination.gsub(/user_id=(\d+)/, "user_id=#{@user.id}&location_id=#{params[:location_id]}")

          redirect_to "http://#{@destination}" and return

        else

          redirect_to "http://#{@destination}#{(!q ? "?" : "")}user_id=#{
          @user.id}&location_id=#{params[:location_id]}" and return

        end

      else

        flash[:notice] = "Password updated!"

        redirect_to "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return

      end

    else

      flash[:notice] = "Password updated!"

      redirect_to "/select_user_task?user_id=#{params[:user_id]}&location_id=#{params[:location_id]}" and return

    end
  end

  def logout
    user = CoreUserProperty.find_by_user_id_and_property(params[:id], "Token") rescue nil

    file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

    if File.exists?(file)

      File.delete(file)

    end

    if user
      user.delete      

      flash[:notice] = "You've been logged out"
    end

    redirect_to "/login" and return
  end

  def verify
    demo = CoreUser.find(params[:user_id] || params[:id]).demographics rescue {}

    render :text => demo.to_json
  end

  def location

    if !params[:src].nil?
      # Track final destination
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"

      f = File.open(file, "w")

      f.write("#{Rails.env}:\n    host.path.login: #{params[:src] rescue ""}?user_id=#{@user.id}")

      f.close

      @destination = nil

      if File.exists?(file)

        @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

      end
    end

  end

  def location_update

    if params[:location].strip.match(/^\d+$/)

      @location = CoreLocation.find(params[:location]) rescue nil

    else
      
      @location = CoreLocation.find_by_name(params[:location]) rescue nil

    end

    if @location.nil?

      flash[:error] = "Invalid location"
      
      redirect_to "/location?user_id=#{@user.id}" and return

    end

    if !params[:src].nil?
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.#{@user.id}.yml"
    else
      file = "#{File.expand_path("#{Rails.root}/tmp", __FILE__)}/user.login.yml"
    end

    @destination = nil

    if File.exists?(file)

      @destination = YAML.load_file(file)["#{Rails.env
        }"]["host.path.login"].strip

    end

    if !@destination.nil?
      q = (@destination.match(/\?/))
      u = (@destination.match(/user_id=(\d+)/))

      if u

        @destination = @destination.gsub(/user_id=(\d+)/, "user_id=#{@user.id}&location_id=#{@location.id}")

        redirect_to "http://#{@destination}" and return

      else

        # raise "http://#{@destination}#{(!q ? "?" : "")}user_id=#{user.id}".to_yaml

        redirect_to "http://#{@destination}#{(!q ? "?" : "")}user_id=#{@user.id}&location_id=#{@location.id}" and return

      end

    else

      redirect_to "http://#{request.raw_host_with_port}?user_id=#{@user.id}&location_id=#{@location.id}" and return

    end
    
  end

  def user_demographics
    render :layout => false
  end

  protected
  
  def check_user
    
    @user = CoreUser.find(params[:id] || params[:user_id]) rescue nil

    if @user.nil?
      redirect_to "/login" and return
    end

    if !@user.logged_in?
      redirect_to "/login" and return
    end

  end

  def check_location

    @location = CoreLocation.find(params[:location_id]) rescue nil

    if @location.nil?
      redirect_to "/location?user_id=#{@user.id rescue nil}" and return
    end

  end

end