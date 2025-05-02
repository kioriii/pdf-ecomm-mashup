class CreateAdminDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_documents do |t|
      t.text :name

      t.timestamps
    end
  end
end
