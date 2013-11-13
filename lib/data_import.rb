class DataImport

  def initialize(file_name)
    @file_name = file_name
  end

  def process!
    #need to add logic to handle multiple sheets
    spreadsheet = Roo::Spreadsheet.open(@file_name)
    header = spreadsheet.row(1).map(&:downcase)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      #next if Need.where(nid: row['needid']).exists?
      loc = Geocoder.search("#{row['agencyaddress']} #{row['agencycity']} #{row['agencystate']} #{row['agencyzip'].to_i}")
      begin
      need = Need.create(
          :nid => row['needid'],
          :title => row['needtitle'],
          :description => row['description'],
          :agency_id => row['agencyid'],
          :agency_name => row['agencyname'],
          :category => row['category'],
          :address => row['agencyaddress'],
          :city => row['agencycity'],
          :zip_code => row['agencyzip'],
          :state => row['agencystate'],
          :phone => row['phone'],
          :email => row['email'],
          :loc => loc.first.data['displayLatLng'].values
      )
        need.save!
      rescue
        next
      end


    end

  end

end