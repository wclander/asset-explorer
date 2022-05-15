class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.string :character_owner_hash
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :characters, :character_owner_hash, unique: true
  end
end
