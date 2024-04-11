class Comment < ActiveRecord::Migration[7.1]
  def change
    create_table :Comments do |t|
      t.integer :feacture_id
      t.string :body
      t.timestamps
    end
    
  end
end