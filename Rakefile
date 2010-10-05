require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "curdbee"
    gem.summary = %Q{Ruby wrapper for the CurdBee API}
    gem.email = "lakshan@vesess.com"
    gem.homepage = "http://github.com/vesess/curdbee"
    gem.authors = ["Lakshan Perera"]

    gem.add_dependency('httparty', '~> 0.5.2')
    gem.add_dependency('hashie', '~> 0.1.8')
    gem.add_dependency('json')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
