class Component < ActiveRecord::Base
  translates :title, :text
  belongs_to :page, :counter_cache => true
  belongs_to :source, :class_name => "Page", :foreign_key => :source_page
  acts_as_list :scope => :page_id
  has_many :documents
  validates_presence_of :title
  
  # Strip any speech marks and replace with a marker
  def before_save
    self.text = text.gsub(/["]/, '[s-mark]') unless !self.text_changed?
  end
  
  def snippets
    if snippet_class == "Event"
      Event.future_events(DateTime.now.year, DateTime.now.month, limit)
    else
      snippet_class.constantize.find(:all, :order => order, :limit => limit, :conditions => ["page_id = ?", source_page])
    end
  end
  
  def page_feed?
    true if component_type == "pagefeed"
  end
  
  def documents?
    true if component_type == "documents"
  end
  
  def text?
    true if component_type == "text"
  end
  
  def ordered_documents
    Document.find(:all, :conditions => ["component_id = ?", self.id], :order => order)
  end
  
  ORDER_OPTIONS = [
    [ 'Created Descending', 'created_at DESC' ],
    [ 'Created Ascending', 'created_at ASC' ],
    [ 'Title Descending', 'title DESC' ],
    [ 'Title Ascending', 'title ASC' ]
  ]
  
  LIMIT_OPTIONS = [
    [ '1 Item', 1 ],
    [ '3 Items', 3 ],
    [ '5 Items', 5 ],
    [ '10 Items', 10 ]
  ]
end
