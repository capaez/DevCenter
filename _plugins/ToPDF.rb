# require 'pry'
# require 'pry-byebug'
require 'pdfkit'
require 'fileutils'
PDFKit.configure do |config|
  # config.wkhtmltopdf = '/path/to/wkhtmltopdf'
  config.default_options = {
    page_size: 'A4',
    print_media_type: true
  }
  config.root_url = 'https://pages.github.ibm.com'
  config.verbose = true
end

Jekyll::Hooks.register :site, :post_write do |site|
  site.pages.each do |page|
    next unless page.data['print_pdf']
    # next unless page.url == '/tutorials/en/foundation/6.3/hello-world/previewing-application-mobile-web-desktop-browser/'
    # binding.pry
    prefix_folder = site.config['destination'] + '/pdf'
    # binding.pry
    # Create the directory if not exists
    parts = page.url.split('/')
    parts.pop
    parent_folder = prefix_folder + parts.join('/') + '/'
    FileUtils.mkdir_p(parent_folder) unless File.exist?(parent_folder)

    # Define the file path
    file_name = prefix_folder + page.url.chomp('/') + '.pdf'

    # Generate the PDF
    kit = PDFKit.new('https://pages.github.ibm.com/MFPSamples' + page.url + 'index.html')
    # kit.stylesheets << site.config['destination'] + '/css/combined.css'
    file = kit.to_file(file_name)
  end
end