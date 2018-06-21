class TopCompanies::Company
    attr_accessor :name, :ceo, :sector, :location, :website, :slug

    @@all = []

    def initialize(company_hash)
        company_hash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
        @@all << self
    end

    def self.create_from_collection(companies_array)
        companies_array.each do |company_hash|
            TopCompanies::Company.new(company_hash)
        end
    end

    def add_attributes(company_hash)
        company_hash.each do |attribute, value|
            self.send("#{attribute}=", value)
        end
    end

    def self.all
        @@all
    end
end