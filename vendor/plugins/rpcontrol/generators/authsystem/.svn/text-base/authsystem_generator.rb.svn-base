class AuthsystemGenerator <  Rails::Generator::Base
  def manifest
    recorded_session = record do |m|
      # models
      m.file "models/user.rb", "app/models/user.rb"
      m.file "models/user_session.rb", "app/models/user_session.rb"
      m.file "models/role.rb", "app/models/role.rb"
      m.file "models/permission.rb", "app/models/permission.rb"

      # controllers
      m.file "controllers/application.rb", "app/controllers/application.rb"
      m.file "controllers/users_controller.rb", "app/controllers/users_controller.rb"
      m.file "controllers/user_sessions_controller.rb", "app/controllers/user_sessions_controller.rb"
      m.file "controllers/permission_controller.rb", "app/controllers/permission_controller.rb"
      m.file "controllers/role_controller.rb", "app/controllers/role_controller.rb"

      # views
      m.directory "app/views/user_sessions"
      m.file "views/user_sessions/new.html.erb", "app/views/user_sessions/new.html.erb"
      m.directory "app/views/users"
      m.file "views/users/show.html.erb", "app/views/users/show.html.erb"
      m.file "views/users/_form.haml", "app/views/users/_form.haml"
      m.file "views/users/edit.haml", "app/views/users/edit.haml"
      m.file "views/users/new.haml", "app/views/users/new.haml"

      # layout
      m.file "views/layouts/base.haml", "app/views/layouts/base.haml"

      # helpers
      m.file "helpers/users_helper.rb", "app/helpers/users_helper.rb"
      m.file "helpers/user_sessions_helper.rb", "app/helpers/user_sessions_helper.rb"

      # migrates
      m.directory "db/migrate"
      # remove existed migrate file
      Find.find( RAILS_ROOT + '/db/migrate' ) do |file_name|
        if File.basename(file_name)[0] == ?.
          Find.prune
        else
          if /_create_authsystem.rb$/ =~ file_name
            File.delete file_name
          end
        end
      end
      m.file "migrate/create_authsystem.rb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_authsystem.rb"
    end

    action = nil
    action = $0.split("/")[1]
    case action
    when "generate"
      puts
      puts ("-" * 70)
      puts "Don't forget to:"
      puts
      puts " - add restful routes in config/routes.rb"
      puts " map.resource :user_session"
      puts " map.root :controller => \"first_page\""
      puts " map.resource :account, :controller => \"users\""
      puts " map.resources :users"
      puts ("-" * 70)
      puts
      puts " Use db:migrate to prepare the database tables"
      puts
      puts ("-" * 70)
      puts
      puts " *** Do generate authsystem before create your own application.rb file "
      puts " *** Because generate authsystem will cover the application.rb file"
      puts
      puts
    when "destroy"
      puts
      puts ("-" * 70)
      puts
      puts "Thanks for using auth_template"
      puts
      puts ("-" * 70)
      puts
    else
      puts
    end

    recorded_session
  end
end
