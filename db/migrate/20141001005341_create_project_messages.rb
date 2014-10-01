class CreateProjectMessages < ActiveRecord::Migration
  def change
    create_table :project_messages do |t|
      t.text :message
      t.integer :project_id

      t.timestamps
    end
  end
end
