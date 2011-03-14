module CurdBee
 class Base < Hashie::Mash
    include HTTParty
    
    parser CurdBee::Parser
    headers 'Content-Type' => 'application/json'

    class << self; attr_accessor :resource, :element end

    def self.list(opts = {})
      limit = opts[:limit] || 20
      page = opts[:page] || 1

      response = send_request(:get, "/#{self.resource}.json", :query => {'per_page' => limit, 'page' => page })
      response.map {|c| self.new c["#{self.element}"]}
    end

    def self.show(id)
      response = send_request(:get, "/#{self.resource}/#{id}.json")
      #Hashie::Mash.new(response["#{@element}"])
      self.new(response["#{self.element}"])
    end

    def create
      body = {"#{self.class.element}" => self}.to_json
      response = self.class.send_request(:post, "/#{self.class.resource}", :body => body)

      self.id = response["#{self.class.element}"]["id"]
      return true if (response.code.to_i == 201)
    end

    def update(attrs=nil)
      body = {"#{self.class.element}" => (attrs || self)}.to_json
      response = self.class.send_request(:put, "/#{self.class.resource}/#{self[:id]}", :body => body)
      #Hashie::Mash.new(response["#{@element}"])
      return true if (response.code.to_i == 200)
    end

    def delete
       response = self.class.send_request(:delete, "/#{self.class.resource}/#{self[:id]}")
       return true if response.code.to_i == 200
    end

    def self.send_request(method, path, opts={})
      api_key = CurdBee::Config.api_key 
      subdomain = CurdBee::Config.subdomain
      use_https = CurdBee::Config.use_https
      scheme = use_https ? "https" : "http"
 
      self.base_uri "#{scheme}://#{subdomain}.curdbee.com"

      opts[:query] = opts.has_key?(:query) ? opts[:query].merge({'api_token' => api_key}) : {'api_token' => api_key}
      begin
        response = self.send(method, path, opts)
      rescue
        raise(CurdBee::Error::ConnectionFailed.new, "Failed to connect to server.")
      end

      case response.code.to_i
      when 401
        raise(CurdBee::Error::AccessDenied.new(response), "Access Denied.")
      when 403
        raise(CurdBee::Error::Forbidden.new(response), "Your action was forbidden.")
      when 422
        raise(CurdBee::Error::BadRequest.new(response), (response.body ? JSON.parse(response.body).join(" ") : "") )
      when 404
        raise(CurdBee::Error::NotFound.new(response), "Resource not found.")
      when 500
        raise(CurdBee::Error::ServerError.new(response), "Error occured in server.")
      end

      response
    end    
  end
end
