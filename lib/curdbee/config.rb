module CurdBee
 class Config

    @@api_key = "your_api_key"
    @@subdomain = "subdomain"
    @@use_https = true 

    def self.api_key=(api_key)
      @@api_key = api_key
    end

    def self.api_key
      @@api_key
    end

    def self.subdomain=(subdomain)
      @@subdomain = subdomain
    end

    def self.subdomain
      @@subdomain
    end

    def self.use_https=(use_https)
      @@use_https = use_https
    end

    def self.use_https
      @@use_https
    end

 end
end
