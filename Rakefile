desc 'Run all tests'
task :test do
  $LOAD_PATH.unshift 'test'
  Dir.glob('./test/**/*_test.rb') { |f| require f }
end

desc 'Start server'
task :server do
  system 'bundle exec rackup -p 9292 config.ru'
end

desc 'Print bash friendly version of Heroku config'
task :config do
  vars = {
    "CHARTBEAT_API_KEY" => "",
    "CHARTBEAT_DOMAIN"  => "",
    "LIBSYN_EMAIL"      => "",
    "LIBSYN_PASSWORD"   => "",
    "LIBSYN_SHOW_ID"    => ""
  }

  `heroku config`.split("\n").each do |line|
    var, value = line.split(':')
    vars[var] = value.strip if vars.keys.include?(var)
  end

  vars.each { |var, value| puts "export #{var}='#{value}'" }
end

task default: :test
