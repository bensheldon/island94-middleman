###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  blog.permalink = "{year}/{month}/{title}.html"
  # Matcher for blog source files
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "article"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
set :file_watcher_ignore, [
    /^\.idea\//,
    /^\.bundle\//,
    /^\.sass-cache\//,
    /^\.git\//,
    /^\.gitignore$/,
    /\.DS_Store/,
    /^build\//,
    /^\.rbenv-.*$/,
    /^Gemfile$/,
    /^Gemfile\.lock$/,
    /~$/,
    /(^|\/)\.?#/
]
activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


set :markdown_engine, :kramdown
set :markdown, layout_engine: :haml,
               input: 'GFM',
               tables: true,
               autolink: true,
               smartypants: true,
               fenced_code_blocks: true

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'island94.org'
  s3_sync.region                     = 'us-east-1'
  s3_sync.aws_access_key_id          = ENV['AWS_ACCESS_KEY_ID']
  s3_sync.aws_secret_access_key      = ENV['AWS_SECRET_ACCESS_KEY']
  s3_sync.delete                     = true
  s3_sync.after_build                = false
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
end

activate :s3_redirect do |s3_redirect|
  s3_redirect.bucket                     = 'island94.org'
  s3_redirect.region                     = 'us-east-1'
  s3_redirect.aws_access_key_id          = ENV['AWS_ACCESS_KEY_ID']
  s3_redirect.aws_secret_access_key      = ENV['AWS_SECRET_ACCESS_KEY']
  s3_redirect.after_build            = false
end

ready do
  # global redirects
  data.global_redirects.each do |target, sources|
    Array(sources).each do |source|
      # puts "#{source} -> #{target}"
      if ::Middleman::Extensions.registered.has_key?(:s3_redirect)
        redirect "/#{source}", "/#{target}"
      else
        redirect source, to: target
      end
    end
  end

  # blog redirects
  blog.articles.each do |article|
    article.data.fetch('redirects', []).each do |source|
      target = article.request_path
      # puts "#{source} -> #{target}"
      if ::Middleman::Extensions.registered.has_key?(:s3_redirect)
        redirect "/#{source}", "/#{target}"
      else
        redirect source, to: target
      end
    end
  end
end
