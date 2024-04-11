class FeaturesController < ApplicationController

  #http://127.0.0.1:3000/api/features?page=1&per_page=100&filters[mag_type]=mw (GET)
    def index
    features = Earthquake.all 
    # Filtro por tipo de magnitud si se proporciona un filtro y el valor del filtro no está en blanco
    features = filter_by_mag_type(features, params[:filters][:mag_type]) if params[:filters] && params[:filters][:mag_type].present?
    
    # Paginar la lista de características utilizando los parámetros de página y por página proporcionados
    features = features.paginate(page: params[:page], per_page: per_page_param)
    total_pages = (features.count.to_f / features.limit_value.to_f).ceil #Calculo las paginas totales tomando en cuenta los filtros

    render json: {
      data: serialize_features(features),
      pagination: {
        current_page: features.current_page,
        total: total_pages,
        per_page: features.limit_value,
        
      }
    }
  end

  private

  def filter_by_mag_type(features, mag_types)
    mag_types = mag_types.split(',') if mag_types.is_a?(String)
    features.where(mag_type: mag_types)
  end

  #
  def serialize_features(features)
    features.map do |feature| # Mapeo cada característica y la convierte en un hash con los datos serializados
      {
        id: feature.id,
        type: 'feature',
        attributes: {
          external_id: feature.feacture_id,
          magnitude: feature.mag,
          place: feature.place,
          time: feature.time.strftime('%Y-%m-%d %H:%M:%S'),
          tsunami: feature.tsunami != 0,
          mag_type: feature.mag_type,
          title: feature.title,
          coordinates: {
            longitude: feature.longitude,
            latitude: feature.latitude
          }
        },
        links: {
          external_url: feature.url
        }
      }
    end
  end

  def per_page_param
    [params[:per_page].to_i, 1000].min
  end

end

