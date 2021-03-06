require 'rake'
module NpmAssets
  class Rails < Rails::Railtie
    initializer "npm_assets.add_npm_require_directive_processor" do |app|
      app.assets.unregister_processor('application/javascript', Sprockets::DirectiveProcessor)
      app.assets.register_processor "application/javascript", NpmAssets::NpmRequireProcessor
    end
    initializer "npm_assets.add_asset_paths" do |app|
      FileList["#{app.root}/**/node_modules/*"].each do |dir|
        package = ActiveSupport::JSON.decode(File.read(File.join(dir, "package.json")))
        match = package["main"].match(/.*\//)
        app.config.assets.paths << (match ? File.join(dir, match[0]) : dir)
      end
    end
    rake_tasks do
      load "tasks/npm_assets.rake"
    end
  end
end