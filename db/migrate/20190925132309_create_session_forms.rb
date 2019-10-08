class CreateSessionForms < ActiveRecord::Migration[6.0]
  def change
    create_table :session_forms do |t|
      t.references :session, null: false, foreign_key: true
      t.references :form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
