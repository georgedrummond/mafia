require "version"
require "thor/group"

module Mafia
  module Helpers
    def camelize(string)
      string.split(/[\W_]/).map {|c| c.capitalize}.join
    end
  end
  
  class Generator < Thor::Group
    include Thor::Actions
    include Mafia::Helpers
    
    argument :name
    
    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'mafia/templates'))
    end
    
    def create_gemspec_file
      opts = {
        :name => name,
        :creator_name => `git config user.name`.chomp,
        :creator_email => `git config user.email`.chomp
      }
      
      template("gemspec.tt", "#{name}/#{name}.gemspec", opts)
    end
    
    def create_config_ru_file
      template("config.ru.tt", "#{name}/config.ru")
    end
    
    def create_version_file
      template("version.rb.tt", "#{name}/lib/version.rb")
    end

    def create_bin_file
      if yes? "\n\nCreate a binary to run your application?", :green
        template("bin.tt", "#{name}/bin/#{name}")
        insert_into_file "#{name}/#{name}.gemspec", "  s.add_dependency \"OptionParser\"\n", :after => "s.add_dependency \"sass\"\n"
      end
    end

    def create_gem_file
      template("gem.rb.tt", "#{name}/lib/#{name}.rb")
    end
    
    def create_app_file
      template("app.rb.tt", "#{name}/lib/#{name}/app.rb")
    end
    
    def copy_rakefile
      copy_file("Rakefile", "#{name}/Rakefile")
    end
    
    def create_gemfile
      template("Gemfile.tt", "#{name}/Gemfile")
    end
    
    def copy_readme
      template("README.md.tt", "#{name}/README.md")
    end
    
    def create_empty_files_and_directories
      empty_directory("#{name}/lib/#{name}/public")
      empty_directory("#{name}/lib/#{name}/views")
      empty_directory("#{name}/lib/#{name}/lib")      
    end
    
    def include_helpers
      if yes? "\n\nInstall georgedrummond_sinatra_helpers gem into app?", :green
        insert_into_file "#{name}/#{name}.gemspec", "  s.add_dependency \"georgedrummond_sinatra_helpers\"\n", :after => "s.add_dependency \"sass\"\n"
        insert_into_file "#{name}/lib/#{name}/app.rb", "    include GeorgeDrummond::Sinatra::Helpers\n", :after => "class Application < Sinatra::Base\n"
        insert_into_file "#{name}/lib/#{name}/app.rb", "require \"georgedrummond_sinatra_helpers\"\n", :after => "require \"sass\"\n"
      end
    end
    
    def create_license
      if yes? "\n\nUse MIT License?", :green
        
        opts = {
          :name => name,
          :creator_name => `git config user.name`.chomp,
          :creator_email => `git config user.email`.chomp
        }
        
        template("LICENSE.tt", "#{name}/LICENSE", opts)
      end
    end
    
    def initalize_git_repo
      target = File.join(Dir.pwd, name)
      say "\n\nInitializating git repo in #{target}", :green
      Dir.chdir(target) { 
        run "git init", :verbose => false
        run "git add .", :verbose => false
      }
    end
    
    def run_bundle_command
      target = File.join(Dir.pwd, name)
      say "\n\nRunning Bundler", :green
      Dir.chdir(target) { 
        run "bundle install", :verbose => false
      }
    end
    
    def show_complete_message
      complete = <<-COMPLETE   
      
Sinatra gem has been generated

For help using sinatra please visit www.sinatrarb.com

COMPLETE
   
      say complete, :green
        
    end
  end
end
