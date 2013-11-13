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

      agency = Agency.find_or_create_by(id: row['agencyid'], name: row['agency_name'], phone: row['phone'], email: row['email'])
      address = Address.create(street: row['agencyaddress'], city: row['agencycity'], state: row['agencystate'], zip: row['agencyzip'], location: loc.first.data['displayLatLng'].values, agency_id: agency.id)
      need = Need.create(
          :nid => row['needid'],
          :title => row['needtitle'],
          :description => row['description'],
          :agency_id => agency.id,
          :category => row['category'],
      )
        need.save!
      rescue
        next
      end


    end
    process2(spreadsheet.sheet('DonationData'))
  end

  def process2(spreadsheet)
    header = spreadsheet.row(1).map(&:downcase)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.find_or_create_by(donor_id: row['donorid'], name: "#{row['firstname'].strip} #{row['lastname'].strip}", password: '12345678')
      donation = Donation.create(
          :user_id => user.id,
          :category => row['category'],
          :transaction_date => row['transaction_date'],
          :transaction_amount => row['transaction_amount']
      )
      begin
        donation.save!
      rescue => e
        p e
        next
      end
    end
  end

end