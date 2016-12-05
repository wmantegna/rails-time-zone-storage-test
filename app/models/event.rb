class Event < ActiveRecord::Base

  def in_time_zone
    return self.start.in_time_zone(self.time_zone)
  end
  def in_time_zone_string
    return self.in_time_zone.strftime('%Y-%m-%d %H:%M %Z')
  end


  def rewind_datetime_for_editing
    diff = UtilsDatetime::get_time_zone_offset(self.time_zone)

    self.start = self.start + diff.hours
  end


  # Querying
  # ----------------------
  def self.get_after_date(date)
    return Event.where("start >= ?", date)
  end
  # ----------------------
end
