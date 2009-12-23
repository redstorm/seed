namespace :db do
  desc "Initialize the minimum required database contents: admin user & role and a single page"
  task :init => ['environment'] do
    require 'fileutils'
    require 'highline/import'
    email, password = ask("enter admin email: "), ask("enter admin password: ")
    locale = ask("enter a locale to start with, or hit enter (default 'en'): ")
    locale = 'en' if locale == ''

    Dir['config/examples/*'].each do |source|
      destination = "config/#{File.basename(source)}"
      if File.exist? destination
        puts "#{destination} exists... skipping"
      else
        FileUtils.cp(source, destination)
        puts "Generated #{destination}"
      end
    end

    I18n.locale = locale.to_sym

    # admin role
    admin_role = Role.create( :name => "admin", :description => "Site Administrator" )

    # admin user
    u = User.new
    u.name = "Administrator"
    u.email = email
    u.login = 'admin'
    u.password = u.password_confirmation = password
    u.roles << admin_role
    u.activated_at = Time.now
    u.save!

    # a page to start with (seed throws an exception when you visit the default route if there are 0 pages)
    p = Page.new
    p.id = 1
    p.title = p.name = "Main page"
    p.description = "A page to start with"
    p.save!
    
    puts <<-complete
  
    ==Seed Setup Complete==
  
      You should now:
       - Customise config/settings.yml to suit your requirements
       - Replace the secret key in config/environment.rb with a new key (generate with "rake secret")
       - start a server and visit /en/login
  
    complete
  end
end
