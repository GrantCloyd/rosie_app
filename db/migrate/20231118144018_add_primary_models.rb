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
      t.references :user, foreign_key: true, index: {unique: true}
      t.boolean :moderator_email_notifications, default: true
      t.boolean :subscriber_email_notifications, default: true

      t.timestamps
    end

    create_table :user_topics do |t|
      t.integer :role, null: false
      t.belongs_to :user, index: {unique: true}
      t.belongs_to :topic, index: {unique: true}

      t.timestamps
    end

    create_table :topics do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, default: 0
      t.belongs_to :moderator, foreign_key: {to_table: :user_topics}
      t.belongs_to :subscriber, foreign_key: {to_table: :user_topics}
      
      t.timestamps
    end

    create_table :posts do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :content, null: false
      t.integer :status, default: 0
      t.belongs_to :topics, foreign_key: true, index: {unique: true}
      
      t.timestamps
    end

    create_table :comments do |t|
      t.belongs_to :user, foreign_key: true, index: {unique: true}
      t.text :content, null: false
      t.references :commentable, polymorphic: true

      t.timestamps
    end

    create_table :user_reactions do |t|
      t.belongs_to :user, foreign_key: true, index: {unique: true}
      t.integer :reaction_status, null: false
      t.references :reactionable, polymorphic: true
      
      t.timestamps
    end

    create_table :invitations do |t| 
      t.belongs_to :topic, foreign_key: true, index: {unique: true}
      t.belongs_to :user, foreign_key: true, index: {unique: true}
      t.text :note
      t.string :target_email, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
