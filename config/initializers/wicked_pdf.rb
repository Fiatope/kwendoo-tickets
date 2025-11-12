WickedPdf.config do |config|  
  if Rails.env.production?
    config.exe_path = Rails.root.to_s + "/bin/wkhtmltopdf"
  elsif /darwin/ =~ RUBY_PLATFORM
    config.exe_path = "/Users/alexandre/.rbenv/shims/wkhtmltopdf"
  elsif /linux/ =~ RUBY_PLATFORM
    config.exe_path = '/usr/bin/wkhtmltopdf'
  else
    raise "UnableToLocateWkhtmltopdf"
  end
end
