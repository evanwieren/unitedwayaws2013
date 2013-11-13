class AdminController < ApplicationController
  def index
  end

  def import
    file_name = 'uploads/' + "#{params['file'].original_filename}"
    File.open(file_name, 'wb') do |f|
      f.write(params['file'].tempfile.read)
    end
    DataImport.new(file_name).process!
  end
end