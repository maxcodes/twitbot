class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.boolean :we_currently_follow_them, null: false, default: false
      t.boolean :we_followed_them_in_the_past, null: false, default: false
      t.integer :user_id, null: false, limit: 8
    end
  end

end
