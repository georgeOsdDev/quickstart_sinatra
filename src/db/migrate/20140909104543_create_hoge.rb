class CreateHoge < ActiveRecord::Migration
  def change
    create_table :hoges do |t|
      t.string :name
      t.string :desc
      t.timestamps
    end
  end
end
