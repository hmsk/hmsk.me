require 'digest/md5'

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

helpers do
  def gravatar_for(email)
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    "http://www.gravatar.com/avatar/#{hash}"
  end

  def accounts_by_line
    accounts = data.external_accounts
    cycled_lines =[]
    line =[]
    accounts.each do |key, account|
      cycle_size = cycled_lines.size.even? ? 4 : 3
      line << account
      if line.size == cycle_size
        cycled_lines << line
        line = []
      end
    end
    cycled_lines
  end
end

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
