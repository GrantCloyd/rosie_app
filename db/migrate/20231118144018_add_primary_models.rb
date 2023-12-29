# frozen_string_literal: true

class AddPrimaryModels < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, default: 0

      t.timestamps
    end

    create_table :user_preferences do |t|
      t.references :user, foreign_key: true, index: { unique: true }, null: false
      t.boolean :moderator_email_notifications, default: true
      t.boolean :subscriber_email_notifications, default: true

      t.timestamps
    end

    create_table :groups do |t|
      t.string :title, null: false
      t.integer :status , null: false, default: 0

      t.timestamps
    end

    create_table :user_groups do |t|
      t.integer :role, null: false, default: 0 
      t.integer :privacy_tier, null: false, default: 0 
      t.belongs_to :user, foreign_key: true,  null: false
      t.belongs_to :group, foreign_key: true, null: false

      t.timestamps
    end

    create_table :sections do |t|
      t.belongs_to :group, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, null: false, default: 0
      t.integer :privacy_tier, null: false, default: 0

      t.timestamps
    end

    create_table :section_role_permissions do |t|
      t.belongs_to :section, foreign_key: true, null: false
      t.integer :role_tier, null: false
      t.integer :permission_level, null: false

      t.timestamps
    end

    create_table :user_group_sections do |t|
      t.belongs_to :section, foreign_key: true,  null: false
      t.belongs_to :user_group, foreign_key: true, null: false
      t.integer :permission_level, null: false, default: 0

      t.timestamps
    end

    create_table :posts do |t|
      t.string :title, null: false
      t.integer :status, default: 0
      t.belongs_to :section, foreign_key: true, null: false
      t.belongs_to :user_group_section, foreign_key: true, null: false
      t.datetime :published_on

      t.timestamps
    end

    create_table :comments do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.text :content, null: false
      t.references :commentable, polymorphic: true, null: false

      t.timestamps
    end

    create_table :user_reactions do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.integer :reaction_status, null: false
      t.references :reactionable, polymorphic: true, null: false

      t.timestamps
    end

    create_table :invites do |t|
      t.belongs_to :group, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true
      t.text :note
      t.string :target_email, null: false
      t.integer :status, default: 0
      t.integer :role_tier, default: 0
      t.integer :privacy_tier, default: 0

      t.timestamps
    end

    add_index :user_groups, [:user_id, :group_id], unique: true
    add_index :user_group_sections, [:user_group_id, :section_id], unique: true
    add_index :invites, [:target_email, :group_id], unique: true
    add_index :section_role_permissions, [:section_id, :role_tier], unique: true
  end
end
