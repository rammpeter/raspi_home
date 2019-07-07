class IndexCreatedAt < ActiveRecord::Migration[5.2]
  def change
    add_index :temperaturs, :created_at
  end
end

