class AddTransferIdToDeploy < ActiveRecord::Migration
  def change
    add_column :deploys, :transfer_id, :string
  end
end
