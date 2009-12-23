class Image < ActiveRecord::Base
  belongs_to :article
  
  named_scope :originals, :conditions => ["parent_id IS NULL"]
  
  has_attachment   :content_type => :image,
                   :path_prefix  => 'public/imageupload',
                   :processor => 'rmagick',
                   :storage => :file_system, 
                   :max_size => 1024.kilobytes, # 1MB
                   :resize_to => '500x500>',
                   :thumbnails => { :thumb100 => '100x100>', 
                                    :thumb200 => '200x200>', 
                                    :thumb300 => '300x300>',
                                    :thumb400 => '400x400>' }

  validates_as_attachment
  
  def thumbnail_size(thumb)
    if !thumb.nil?
      i = Image.find(:first, 
                     :select => "height, width", 
                     :conditions => ["parent_id = ? AND thumbnail = ?", self.id, thumb])
      
      return i.nil? ?
       "0x0" :
       "#{i.width}x#{i.height}"
    end
  end
  
end
