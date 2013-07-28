class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.references :user, index: true
      t.hstore :create_response

      t.timestamps
    end
  end
end
