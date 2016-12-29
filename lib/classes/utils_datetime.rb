class UtilsDatetime

  # Constants
  DATETIME_FORMAT = "%m/%d/%Y %H:%M"


  def self.encode_for_time_zone(datetime, timeZone)
    diff = get_time_zone_offset(timeZone)
    parsed_datetime = encode_time_zone(datetime, diff)
    return parsed_datetime
  end

  def self.encode_time_zone(datetime, timeZoneOffset)
    raise ArgumentError.new('datetime must be a DateTime') unless datetime.is_a?(DateTime)
    raise ArgumentError.new('timeZoneOffset must be an Integer') unless timeZoneOffset.is_a?(Integer)

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
    raise ArgumentError.new('date must be a Date') unless date.is_a?(Date)
    raise ArgumentError.new('time must be a Time') unless time.is_a?(Time)

    datetime = DateTime.new(date.year, date.month, date.day, time.hour, time.min)
    return datetime
  end

  def self.handle_daylight_savings(time)
    raise ArgumentError.new('time must be a Time') unless time.is_a?(Time)

    # http://stackoverflow.com/a/12065605/3205851  
    if time.dst?
      if Time.now.dst?
        time = time + 1.hour
      else
        time = time - 1.hour
      end
    end

    return time
  end

  def self.replace_dst_time_zone_names(str)
    # NOTE: this needs to be replaced by updating the time-zone 'diff' 
    # to reflect a number that stops the daylight savings time-zone name to begin with 
    # see: encode_for_time_zone() for more info on what time-zone 'diff' is

    raise ArgumentError.new('string must be a String') unless str.is_a?(String)

    # dst = Daylight Savings Time
    time_zone_names_to_replace = [
      {non_dst: 'EST', dst: 'EDT'},
      {non_dst: 'CST', dst: 'CDT'},
      {non_dst: 'MST', dst: 'MDT'},
      {non_dst: 'PST', dst: 'PDT'}
    ]

    time_zone_names_to_replace.each do |pair|
      str.sub! pair[:dst], pair[:non_dst]
    end

    return str
  end

end