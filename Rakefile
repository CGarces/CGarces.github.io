require 'html-proofer'
require 'yaml'

namespace :assets do
  task :precompile do
    sh 'bundle exec jekyll build'
  end
end

def config
  config = YAML.load_file('_config_'  +  ENV['RAILS_ENV'] + '.yml')
  config['proofer'].keys.each do |key|
    config['proofer'][key.to_sym] = config['proofer'].delete(key)
  end
  config
end

def serve_site
  sh 'bundle exec jekyll serve -H $IP -P $PORT -c _config.yml,_config_'  +  ENV['RAILS_ENV'] + '.yml  --detach'
end

def html_proofer
  puts "HTML Proofer version: #{HTMLProofer::VERSION}"
  HTMLProofer.check_directory('./_site', config['proofer']).run
end

task :test do
  begin
    serve_site
    html_proofer
  ensure
    `pkill -f jekyll`
  end
end
