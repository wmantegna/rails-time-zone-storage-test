module DatetimeHelper
  def self.encodeForTimeZone(datetime, timeZone)
    # get time zone info
    diff = getTimeZoneOffset(timeZone)

    # get datetime info
    datetime_format = "%m/%d/%Y %H:%M"
    datetime_str = datetime.strftime(datetime_format)

    # build final datetime object
    parsed_datetime = DateTime.strptime("#{datetime_str} #{diff}", "#{datetime_format} %Z")
    
    return parsed_datetime
  end

  def self.getTimeZoneOffset(timeZone)
    zone = ActiveSupport::TimeZone[timeZone]
    diff = zone.formatted_offset

    return diff.to_i
  end
end
