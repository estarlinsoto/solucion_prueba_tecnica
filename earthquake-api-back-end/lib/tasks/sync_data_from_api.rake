namespace :sync_data_from_api do
    desc "Synchronize earthquake data from API to database"
  task :sync => :environment do
    require 'net/http'
    require 'json'

    #Hago la estructura para hacer el get a la API
    url = URI.parse('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true #utilizo el ssl para poder efectuar el get
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    data = JSON.parse(response.body)

    data['features'].each do |feature|
      properties = feature['properties']
      geometry = feature['geometry']
      id = feature['id']

      #Confirmo que los siguientes campos no se repitan en la base de datos 
      next if Earthquake.exists?(title: properties['title'], url: properties['url'], feacture_id: id)

      #Estructuro el objeto antes de ser guardado en la base de datos
      earthquake = Earthquake.new(
        mag: properties['mag'],
        place: properties['place'],
        time: Time.at(properties['time'] / 1000), #Hago una conversion de milisegundos a segundos
        url: properties['url'],
        tsunami: properties['tsunami'] ,
        mag_type: properties['magType'],
        title: properties['title'],
        longitude: geometry['coordinates'][0],
        latitude: geometry['coordinates'][1],
        feacture_id: id
      )

      #Confirmo que el objeto cumple con la estructura requerida antes de proceder con su guardado
      if earthquake.valid?
        earthquake.save
      else
        #Hago el retorno de un mensaje en caso de que no se cumpla
        puts "Error: No se pudo guardar el terremoto #{properties['title']}. Errores: #{earthquake.errors.full_messages}"
      end
    end
  end
end

