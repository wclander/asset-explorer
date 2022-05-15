class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.references :character, null: false, foreign_key: true
      t.string :token
      t.datetime :valid_until
      t.boolean :is_refresh_token

      t.timestamps
    end
    add_index :tokens, :token, unique: true
  end
end
