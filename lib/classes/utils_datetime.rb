class UtilsDatetime

  # Constants
  DATETIME_FORMAT = "%m/%d/%Y %H:%M"


  def self.encode_for_time_zone(datetime, timeZone)
    diff = get_time_zone_offset(timeZone)
    parsed_datetime = encode_time_zone(datetime, diff)
    return parsed_datetime
  end

  def self.encode_time_zone(datetime, timeZoneOffset)
    raise ArgumentError.new('datetime must be a datetime') unless datetime.is_a?(DateTime)
    raise ArgumentError.new('timeZoneOffset must be an integer') unless timeZoneOffset.is_a?(Integer)

    # get datetime info  
    datetime_str = datetime.strftime(DATETIME_FORMAT)

    # build final datetime object
    parsed_datetime = DateTime.strptime("#{datetime_str} #{timeZoneOffset}", "#{DATETIME_FORMAT} %Z")
    
    return parsed_datetime
  end

  def self.get_time_zone_offset(timeZone)
    zone = ActiveSupport::TimeZone[timeZone]
    raise ArgumentError.new('timeZone not found') if zone.nil?

    diff = zone.formatted_offset
    return diff.to_i
  end

  def self.merge_date_and_time(date, time)
    raise ArgumentError.new('date must be a date') unless date.is_a?(Date)
    raise ArgumentError.new('time must be a time') unless time.is_a?(Time)

    datetime = DateTime.new(date.year, date.month, date.day, time.hour, time.min)
    return datetime
  end
end