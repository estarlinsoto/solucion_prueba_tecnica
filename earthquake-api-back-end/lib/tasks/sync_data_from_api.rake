namespace :sync_data_from_api do
    desc "Synchronize earthquake data from API to database"
  task :sync => :environment do
    require 'net/http'
    require 'json'


    url = URI.parse('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    data = JSON.parse(response.body)

    data['features'].each do |feature|
      properties = feature['properties']
      geometry = feature['geometry']
      id = feature['id']

      next if Earthquake.exists?(title: properties['title'], url: properties['url'])

      earthquake = Earthquake.new(
        mag: properties['mag'],
        place: properties['place'],
        time: Time.at(properties['time'] / 1000), #convierto los milisegundos a segundos
        url: properties['url'],
        tsunami: properties['tsunami'] ,
        mag_type: properties['magType'],
        title: properties['title'],
        longitude: geometry['coordinates'][0],
        latitude: geometry['coordinates'][1],
        feacture_id: id
      )

      if earthquake.valid?
        earthquake.save
      else
        puts "Error: No se pudo guardar el terremoto #{properties['title']}. Errores: #{earthquake.errors.full_messages}"
      end
    end
  end
end

