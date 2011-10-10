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
    
    def create_gem_file
      template("gem.rb.tt", "#{name}/lib/#{name}.rb")
    end
    
    def create_app_file
      template("app.rb.tt", "#{name}/lib/#{name}/app.rb")
    end
    
    def copy_rakefile
      copy_file("Rakefile", "#{name}/Rakefile")
    end
    
    def copy_gemfile
      copy_file("Gemfile", "#{name}/Gemfile")
    end
    
    def copy_readme
      template("README.md.tt", "#{name}/README.md")
    end
    
    def create_empty_files_and_directories
      empty_directory("#{name}/lib/#{name}/public")
      empty_directory("#{name}/lib/#{name}/views")
      empty_directory("#{name}/lib/#{name}/lib")      
    end
    
    def create_license
      if yes? "Use MIT License?"
        
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
      say "Initializating git repo in #{target}"
      Dir.chdir(target) { `git init`; `git add .` }
    end
  end
end
