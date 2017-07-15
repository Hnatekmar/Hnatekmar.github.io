require "stringex"

# Převzato z https://gist.github.com/ichadhr/0b4e35174c7e90c0b31b a trochu upraveno pro vlastní potřeby

class Jekyll < Thor
  desc "new", "create a new post"
  method_option :editor, :default => "vim"
  def new(*title)
    title = title.join(" ")
    date = Time.now.strftime('%Y-%m-%d')
    filename = "_posts/#{date}-#{title.to_url}.markdown"

    if File.exist?(filename)
      abort("#{filename} already exists!")
    end

    puts "Creating new post: #{filename}"
    open(filename, 'w') do |post|
      post.puts "---"
      post.puts "layout: post"
      post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
      post.puts "tags:"
      post.puts " -"
      post.puts "---"
    end

    system(options[:editor], filename)
  end
end
