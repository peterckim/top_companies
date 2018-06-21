class TopCompanies::CompanyController
    BASE_URL = "http://fortune.com"

    def run
        make_companies
        intro
        # add_attributes_to_companies
    end

    def intro
        puts "Welcome to Company Lookup App"
        puts "To list all of the Companies, enter 'list companies'"
        puts "To quit, type 'exit'"
        input = gets.strip

        until input == "list companies" || input == "exit" do
            puts "To list all of the Companies, enter 'list companies'"
            puts "To quit, type 'exit'"
            input = gets.strip
        end

        case input
        when "list companies"
            list_companies
        when "exit"
            exit 0
        end

        puts "Please enter the number(s) of the company(ies) you would like to know more about (separated by ','):"
        number = gets.strip
        numbers = number.split(/\s*[,]\s*/)

        numbers.each do |index|
            company = TopCompanies::Company.all[index.to_i - 1]
            company_attributes_hash = TopCompanies::Scraper.scrape_profile_page(BASE_URL + company.slug)
            company.add_attributes(company_attributes_hash)
        end

        numbers.each do |index|
            display_company(index.to_i)
        end
    end

    def list_companies
        TopCompanies::Company.all.each.with_index(1) do |company, index|
            puts "#{index}. #{company.name}"
        end
    end

    def make_companies
        companies_array = TopCompanies::Scraper.scrape_index_page("http://fortune.com/fortune500/list/")
        TopCompanies::Company.create_from_collection(companies_array)
    end
    
    def display_company(index)
        company = TopCompanies::Company.all[index - 1]
        puts "#{company.name.upcase}".colorize(:color => :blue).bold
        puts "  CEO".italic + ": #{company.ceo.name}"
        puts "  Sector".italic + ": #{company.sector.name}"
        puts "  Location".italic + ": #{company.location}"
        puts "  Website".italic + ": #{company.website}"
        puts "----------------------"
    end
end