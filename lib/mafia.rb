require "version"
require "thor/group"

module Mafia
  class Generator < Thor::Group
    include Thor::Actions
    
    argument :name
    
    def self.source_root
      File.dirname(__FILE__)
    end
    
    def create_gemspec_file
      template("mafia/templates/gemspec.tt", "#{name}/#{name}.gemspec")
    end
    
    def create_config_ru_file
      template("mafia/templates/config.ru.tt", "#{name}/config.ru")
    end
    
    def create_version_file
      template("mafia/templates/version.rb.tt", "#{name}/lib/version.rb")
    end
    
    def create_gem_file
      template("mafia/templates/gem.rb.tt", "#{name}/lib/#{name}.rb")
    end
    
    def create_app_file
      template("mafia/templates/app.rb.tt", "#{name}/lib/#{name}/app.rb")
    end
    
    def copy_rakefile
      copy_file("mafia/templates/Rakefile", "#{name}/Rakefile")
    end
    
    def copy_gemfile
      copy_file("mafia/templates/Gemfile", "#{name}/Gemfile")
    end
    
    def copy_readme
      copy_file("mafia/templates/README", "#{name}/README")
    end
    
    def create_empty_files_and_directories
      empty_directory("#{name}/lib/#{name}/public")
      empty_directory("#{name}/lib/#{name}/views")
      empty_directory("#{name}/lib/#{name}/lib")      
    end

  end # Generator
end # Rackgem
