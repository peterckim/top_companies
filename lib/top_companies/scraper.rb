class TopCompanies::Scraper
    def self.scrape_index_page(index_url)
        index_page = Nokogiri::HTML(open(index_url))
        companies = []
        index_page.css(".company-list").css("li").each do |company|
            company_name = company.css(".company-title").text
            profile_slug = company.css("a").attribute("href").value

            companies << {name: company_name, slug: profile_slug}
        end

        companies
    end

    def self.scrape_profile_page(profile_url)
        profile_page = Nokogiri::HTML(open(profile_url))

        attributes_array = profile_page.css(".company-info-card-table").css(".row").css(".company-info-card-data").css("p")
        company_ceo = attributes_array[0].text
        company_sector = attributes_array[2].text
        company_location = attributes_array[4].text
        company_website = profile_page.css(".company-info-card-table").css(".row").css(".company-info-card-data").css("a").text

        ceo = TopCompanies::CEO.new(company_ceo)
        sector = TopCompanies::Sector.new(company_sector)

        company_attributes = {ceo: ceo, sector: sector, location: company_location, website: company_website}
    end
end
