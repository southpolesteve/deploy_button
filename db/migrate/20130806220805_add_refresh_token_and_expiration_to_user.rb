class AddRefreshTokenAndExpirationToUser < ActiveRecord::Migration
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :token_expires_at, :datetime
  end
end
