class AddHerokuIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :heroku_id, :string
  end
end
