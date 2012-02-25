class CreateSeoHistoryMigration < ActiveRecord::Migration
  def self.up

    create_table :seo_histories do |t|
      t.integer :seo_historable_id
      t.string  :seo_historable_type
      t.string  :seo_url
      t.timestamps
    end

    add_index :seo_histories, :seo_historable_id
    add_index :seo_histories, :seo_historable_type
    add_index :seo_histories, :seo_url
  end

  def self.down
    drop_table :seo_histories
  end
end
