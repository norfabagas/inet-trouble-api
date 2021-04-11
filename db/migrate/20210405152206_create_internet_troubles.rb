class CreateInternetTroubles < ActiveRecord::Migration[6.1]
  def change
    create_table :internet_troubles do |t|
      t.references  :user, foreign_key: true
      t.string      :trouble, nullable: false
      t.string      :category, null: true
      t.string      :status, null: true
      t.boolean     :is_predicted, default: false
      t.timestamps
    end
  end
end
