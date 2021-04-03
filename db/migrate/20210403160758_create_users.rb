class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string  :email, unique: true, nullable: false
      t.string  :password_digest, nullable: false
      t.string  :name, nullable: false
      t.timestamps
    end
  end
end
