class AddTranslationTables < ActiveRecord::Migration
  def self.up
    Article.create_translation_table!   :title => :string, :content => :text
    Component.create_translation_table! :title => :string, :text => :text
    Event.create_translation_table!     :name => :string, :description => :string, :location => :string
  end

  def self.down
    Event.drop_translation_table!
    Component.drop_translation_table!
    Article.drop_translation_table!
  end
end
