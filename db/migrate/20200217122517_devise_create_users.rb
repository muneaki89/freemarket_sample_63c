# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nickname,           null: false
      t.string :email,              null: false
      t.string :encrypted_password, null: false
      t.string :last_name,          null: false
      t.string :first_name,         null: false
      t.string :last_name_jp,       null: false
      t.string :first_name_jp,      null: false
      t.integer :birth_year,        null: false
      t.integer :birth_month,       null: false
      t.integer :birth_day,         null: false
      t.integer :phone_number
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at      
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end
end
