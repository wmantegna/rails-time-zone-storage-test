class Event < ActiveRecord::Base
  def in_time_zone
    return self.start.in_time_zone(self.time_zone)
  end
  def in_time_zone_string
    return self.in_time_zone.strftime('%Y-%m-%d %H:%M %Z')
  end

  def rewind_datetime_for_editing
    diff = DatetimeHelper::getTimeZoneOffset(self.time_zone)
    self.start = self.start + diff.hours
  end

  def self.get_after_date(date)
    # return Event.all.select {|e| e.in_time_zone >= date }
    return Event.where("start >= ?", date)
    # return Event.all.select {|e| 
    #   timed = e.in_time_zone
    #   raise
    #   return timed >= date
    # }
  end
end
