class Event < ActiveRecord::Base

  DATETIME_FORMAT = '%Y-%m-%d %H:%M %Z'

  def in_time_zone
    return self.start.in_time_zone(self.time_zone)
  end
  def in_time_zone_str
    return self.in_time_zone.strftime(DATETIME_FORMAT)
  end
  def handle_daylight_savings
    start_in_time_zone = UtilsDatetime::handle_daylight_savings(self.start)
    return start_in_time_zone.strftime(DATETIME_FORMAT)
  end
  def time_zone_and_daylight_savings

    # process & format into string
    start_in_time_zone = self.in_time_zone
    tz_and_dst = UtilsDatetime::handle_daylight_savings(start_in_time_zone)
    tz_and_dst_str = tz_and_dst.strftime(DATETIME_FORMAT)
    
    # Replace Daylight Saving Time (DST) time-zones with their non-DST versions
    tz_and_dst_str = UtilsDatetime::replace_dst_time_zone_names(tz_and_dst_str)

    return tz_and_dst_str
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
