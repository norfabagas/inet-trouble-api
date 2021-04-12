class AddIsReadByAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :internet_troubles, :is_read_by_admin, :string
  end
end
