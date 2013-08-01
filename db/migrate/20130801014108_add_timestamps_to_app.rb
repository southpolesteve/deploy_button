class AddTimestampsToApp < ActiveRecord::Migration
  def change
    add_column :apps, :created_on_heroku_at, :datetime
    add_column :apps, :cloned_at, :datetime
    add_column :apps, :pushed_to_heroku_at, :datetime
    add_column :apps, :transfered_at, :datetime
  end
end
