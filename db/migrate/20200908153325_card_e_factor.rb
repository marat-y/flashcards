class CardEFactor < ActiveRecord::Migration[5.2]
  def up
    add_column :cards, :e_factor, :float, default: 2.5, null: false
    add_column :cards, :repetitions_count, :integer, default: 0, null: false
    add_column :cards, :response_quality, :integer, default: 0, null: false
    remove_column :cards, :leitner_level, :integer, default: 0, null: false

    execute 'UPDATE cards SET e_factor = 2.5, repetitions_count = 0;'
  end

  def down
    remove_column :cards, :e_factor
    remove_column :cards, :repetitions_count
    remove_column :cards, :response_quality
    add_column :cards, :leitner_level, :integer, default: 0, null: false
  end
end
