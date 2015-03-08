class CreateActiveApiTopLevels < ActiveRecord::Migration
  def change
    create_table :active_api_top_levels do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
