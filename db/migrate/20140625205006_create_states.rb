class CreateStates < ActiveRecord::Migration
  def change
    create_table :states, id: false do |t|
      t.string :name
      t.string :abbrev
    end
    add_index :states, :abbrev
    execute 'ALTER TABLE states ADD PRIMARY KEY (abbrev);'
  end
end
