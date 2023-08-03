class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.references :user, null: false, foreign_key: true
      t.string :youtube_url

      t.timestamps
    end
  end
end
