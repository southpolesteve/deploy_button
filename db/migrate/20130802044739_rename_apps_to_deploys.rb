class RenameAppsToDeploys < ActiveRecord::Migration
  def change
    rename_table :apps, :deploys
  end
end
