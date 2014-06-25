class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles, id: false do |t|
      t.integer :trove_id
      t.string :state_abbrev
      t.string :name
      t.date :start_date
      t.date :end_date
      t.string :trove_url
      t.integer :issue_count, default: 0
      t.integer :article_count, default: 0
      t.integer :comment_count, default: 0
      t.integer :tag_count, default: 0

      t.timestamps
    end
    add_index :titles, :trove_id
    add_index :titles, :state_abbrev
    add_index :titles, :issue_count
    add_index :titles, :article_count
    add_index :titles, :comment_count
    add_index :titles, :tag_count
  end
end
