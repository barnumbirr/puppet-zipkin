Facter.add(:zipkin_version) do
    setcode do
        begin
            require 'uri'
            require 'json'
            require 'net/http'

            uri = URI.parse("http://localhost:9411/info")
            request = Net::HTTP::Get.new(uri)

            response = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(request)
            end

            parsed_json = JSON.parse(response.body)
            parsed_json['zipkin']['version']
        rescue
        end
    end
end
