class RenameUidToToken < ActiveRecord::Migration
  def change
    rename_column :users, :uid, :token
  end
end
