require "middleman-core/cli"

class ExportRedirects < Thor
  include Thor::Actions

  namespace :export_redirects

  desc "export_redirects", "Export frontmatter redirects to a csv"
  def export_redirects
    app = ::Middleman::Application.server.inst
    text = ""
    host = "island94.org"

    app.data.global_redirects.each do |target, sources|
    Array(sources).each do |source|
      text << "http://#{host}/#{source}, http://#{host}/#{target}\n"
      text << "http://#{host}/#{source}, http://www.#{host}/#{target}\n"
    end
  end

    app.blog.articles.each do |article|
      article.data.fetch('redirects', []).each do |source|
        target = article.request_path

        text << "http://#{host}/#{source}, http://#{host}/#{target}\n"
        text << "http://#{host}/#{source}, http://www.#{host}/#{target}\n"
      end
    end

    create_file "redirections.txt", text
  end

end
