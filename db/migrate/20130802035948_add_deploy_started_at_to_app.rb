class AddDeployStartedAtToApp < ActiveRecord::Migration
  def change
    add_column :apps, :deploy_started_at, :datetime
  end
end
