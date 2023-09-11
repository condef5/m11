class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :username, index: { unique: true, name: 'unique_usernames' }
      t.string :image
      t.string :provider
      t.string :uid

      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
