set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  # Minify Javascript on build
  activate :minify_javascript
end

ready do
  sprockets.append_path File.join root, 'bower_components'
  sprockets.append_path File.join root, 'bower_components', 'font-awesome', 'fonts' # Define directly for including woff to sprockets
end

