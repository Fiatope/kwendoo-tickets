WickedPdf.configure do |config|
  candidates = [
    ENV['WKHTMLTOPDF_PATH'],
    Rails.root.join('bin', 'wkhtmltopdf').to_s,
    '/usr/bin/wkhtmltopdf',
    '/usr/local/bin/wkhtmltopdf'
  ].compact.uniq

  resolved_path = candidates.find { |path| File.exist?(path) && File.executable?(path) }
  config.exe_path = resolved_path if resolved_path
end
