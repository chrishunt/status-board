require 'net/http'
require 'uri'
require 'csv'

module StatusBoard
  class Libsyn
    attr_reader :email, :password, :show_id

    HOST = 'three.libsyn.com'

    def initialize(email, password, show_id)
      @email    = email
      @password = password
      @show_id  = show_id
    end

    def get
      path = [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/three-month/target/show/id', show_id
      ].join('/')

      resp, data = http.get(path, { 'Cookie' => cookie })

      CSV.parse resp.body
    end

    private

    def cookie
      @cookie ||= begin
        resp, data = http.post \
          '/auth/login',
          "email=#{URI.encode(email)}&password=#{URI.encode(password)}",
          { 'Content-Type'=> 'application/x-www-form-urlencoded' }

        resp.response['set-cookie']
      end
    end

    def http
      @http ||= begin
        http = Net::HTTP.new(HOST, 443)
        http.use_ssl = true
        http
      end
    end
  end
end
