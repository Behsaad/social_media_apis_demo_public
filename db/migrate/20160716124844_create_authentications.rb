class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true, foreign_key: true

      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.datetime :expires_at
    end
  end
end
