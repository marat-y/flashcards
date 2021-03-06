# frozen_string_literal: true

class AddLocaleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :locale, :string, default: 'en', null: false
  end
end
