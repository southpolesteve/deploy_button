class AddOwnerAndNameToApp < ActiveRecord::Migration
  def change
    add_column :apps, :owner, :string
    add_column :apps, :name, :string
  end
end
