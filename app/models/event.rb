class Event < ActiveRecord::Base
  translates :name, :description, :location
  
  belongs_to :page
  validates_presence_of :name, :date
  
  def self.future_events(thisyear, thismonth, limit=30)
    from = Date.new(thisyear, thismonth)
    find(:all, :conditions => ['datetime >= ? OR from_date >= ?', from, from ], :order => "datetime, from_date ASC", :limit => limit)
  end
  
  def self.current_month_events(year, month, page)
    from = Date.new(year, month, 1)
    to = Date.new(year, next_month(month), 1)
    find(:all, :conditions => ["page_id = ? AND datetime BETWEEN ? AND ? OR from_date BETWEEN ? AND ? OR to_date BETWEEN ? AND ?", page.id, from, to, from, to, from, to], :order => "datetime, from_date ASC")
  end
  
  def sortable?
    false
  end
  
  def date
    (all_day?) ? from_date : datetime
  end
  
  def to_param
    "#{id}-#{permalink}" unless id.nil?
  end
  
  def permalink
    name.downcase.gsub(/[^a-z1-9]+/i, '-') unless name.nil?
  end
  
  def title
    name
  end
  
  def component_preview
    if all_day?
      todate = "<br />#{to_date.strftime("%A, %d %B")}" unless to_date.blank? || to_date == from_date
      fromdate = from_date.strftime("%A, %d %B") 
      "#{fromdate} #{todate}"
    else
      datetime.strftime("%A, %d %B %R")
    end
  end
  
  def calendar_date
    (all_day?) ? from_date : Date.parse(datetime.to_s)
  end
  
  def duration
    if (all_day? && from_date == to_date) || (!all_day)
      duration = 1
    else
      duration = (to_date - from_date).to_i
    end
  end
  
  def range
    if duration == 1
      return calendar_date
    else
      date_iterator = from_date - 1.day
      dates = []
      while date_iterator < to_date
        date_iterator += 1.day
        dates << date_iterator
      end
      dates
    end
  end
  
end

private

def days_in_month(year, month)
  Date.new(year, month, -1).day
end

def next_month(month)
  if month == 12
    month = 1
  else
    month = month+1
  end
end
