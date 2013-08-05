class AddStateToDeploy < ActiveRecord::Migration
  def change
    add_column :deploys, :state, :string
  end
end
