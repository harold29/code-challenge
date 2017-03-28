class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :access_token
      t.integer :expires_in
      t.string :refresh_token
      t.string :scope
      t.datetime :created_at
      t.string :token_type
      t.string :email

      t.timestamps
    end
  end
end
