class IndexCreatedAt < ActiveRecord::Migration
  def change
    add_index :temperaturs, :created_at
  end
end

