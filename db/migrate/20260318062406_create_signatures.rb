class CreateSignatures < ActiveRecord::Migration[8.1]
  def change
    create_table :signatures do |t|
      t.string :name
      t.string :address
      t.text :message

      t.timestamps
    end
  end
end
