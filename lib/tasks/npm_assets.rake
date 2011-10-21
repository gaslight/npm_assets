namespace :npm_assets do
    
  task :build_package_json => :environment do
    npms = []
    FileList["app/assets/javascripts/**/*.coffee", "spec/javascripts/**/*.coffee"].each do |f|
      File.new(f).each_line do |line|
        match = line.match(/^#=\s+require_npm\s+([\w_-]*)/)
        npms << match[1] if match
      end
    end
    puts npms.inspect
    pkg = ActiveSupport::JSON.decode(File.read("package.json"))
    npms.each do |npm|
      pkg["dependencies"][npm] = "*" unless pkg["dependencies"].keys.include?(npm)
    end
    File.open("package.json", "w")  { |f| f.puts pkg.to_json }
  end
  
  task :install => :build_package_json do
    exec "npm install"
  end
end
