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
      t.references :user, foreign_key: true, index: {unique: true}, null: false
      t.boolean :moderator_email_notifications, default: true
      t.boolean :subscriber_email_notifications, default: true

      t.timestamps
    end

    create_table :user_topics do |t|
      t.integer :role, null: false
      t.belongs_to :user, null: false
      t.belongs_to :topic, null: false

      t.timestamps
    end

    create_table :topics do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, default: 0
      
      t.timestamps
    end

    create_table :posts do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :content, null: false
      t.integer :status, default: 0
      t.belongs_to :topic, foreign_key: true, null: false
      t.date :published_on
      
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

    create_table :invitations do |t| 
      t.belongs_to :topic, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.text :note
      t.string :target_email, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
