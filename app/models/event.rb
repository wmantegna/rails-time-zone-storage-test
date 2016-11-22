class Event < ActiveRecord::Base
  def in_time_zone
    return self.start.in_time_zone(self.time_zone)
  end
  def in_time_zone_string
    return self.in_time_zone.strftime('%Y-%m-%d %H:%M %Z')
  end
end
