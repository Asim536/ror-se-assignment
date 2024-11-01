require 'net/http'
require 'net/https'

class EmployeeService
  BASE_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze

  def self.fetch_all(page: nil)
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form({ page: page }) if page.present?
    send_request(uri, :get)
  end

  def self.fetch(id)
    uri = URI("#{BASE_URL}/#{id}")
    send_request(uri, :get)
  end

  def self.create(employee_params)
    uri = URI(BASE_URL)
    send_request(uri, :post, employee_params)
  end

  def self.update(id, employee_params)
    uri = URI("#{BASE_URL}/#{id}")
    send_request(uri, :put, employee_params)
  end

  def self.send_request(uri, method, body = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = build_request(uri, method, body)

    response = http.request(request)
    parse_response(response.body)
  end

  def self.build_request(uri, method, body)
    request_class = case method
                    when :get then Net::HTTP::Get
                    when :post then Net::HTTP::Post
                    when :put then Net::HTTP::Put
                    else raise "Unsupported HTTP method: #{method}"
                    end

    request = request_class.new(uri, 'Content-Type' => 'application/json')
    request.body = body.to_json if body
    request
  end

  def self.parse_response(response)
    JSON.parse(response)
  rescue JSON::ParserError
    { error: 'Invalid response format' }
  end
end
