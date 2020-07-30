class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title

      t.timestamps
    end
  end
end
