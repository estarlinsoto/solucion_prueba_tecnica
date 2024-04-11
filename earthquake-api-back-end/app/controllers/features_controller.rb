class FeaturesController < ApplicationController
    def index
    features = Earthquake.all
    features = filter_by_mag_type(features, params[:filters][:mag_type]) if params[:filters] && params[:filters][:mag_type].present?
    features = features.paginate(page: params[:page], per_page: per_page_param)
    total_pages = (features.count.to_f / features.limit_value.to_f).ceil


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

  def serialize_features(features)
    features.map do |feature|
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

