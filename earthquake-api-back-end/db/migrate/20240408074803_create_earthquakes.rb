class CreateEarthquakes < ActiveRecord::Migration[7.1]
  def change
    create_table :earthquakes do |t|
      t.float :mag
      t.string :place
      t.datetime :time
      t.string :url
      t.integer :tsunami
      t.string :mag_type
      t.string :title
      t.float :longitude
      t.float :latitude
      t.string :feacture_id

      t.timestamps
    end
  end
end
