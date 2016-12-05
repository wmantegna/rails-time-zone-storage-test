require 'rails_helper'

describe UtilsDatetime do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '.encode_time_zone()' do

    # constants
    DATE_FORMAT = "%m/%d/%Y"
    TIME_FORMAT ="%H:%M"
    TIME_ZONE_FORMAT = "%Z"

    # re-used var's
    let (:datetime) { DateTime.new(2016, 12, 1, 12, 30)}
    let (:timeZoneOffset) { -5 }
    
    context 'when input IS valid' do
      it 'returns same date' do
        parsed_datetime = UtilsDatetime::encode_time_zone(datetime, timeZoneOffset)
        expect(parsed_datetime.strftime(DATE_FORMAT)).to eq(datetime.strftime(DATE_FORMAT))
      end
      it 'returns same time' do
        parsed_datetime = UtilsDatetime::encode_time_zone(datetime, timeZoneOffset)
        expect(parsed_datetime.strftime(TIME_FORMAT)).to eq(datetime.strftime(TIME_FORMAT))
      end
      it 'returns same time-zone offset' do
        parsed_datetime = UtilsDatetime::encode_time_zone(datetime, timeZoneOffset)
        expect(parsed_datetime.strftime(TIME_ZONE_FORMAT).to_i).to eq(timeZoneOffset)
      end
    end

    context 'when input is NOT valid' do
      it 'datetime is invalid' do
        expect{ UtilsDatetime::encode_time_zone('not a datetime', timeZoneOffset) }.to raise_error(ArgumentError)
      end
      it 'timeZoneOffset is invalid' do
        expect{ UtilsDatetime::encode_time_zone(datetime, 'not an integer') }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".get_time_zone_offset()" do
    context "when input IS valid" do
      it "gets time-zone offset" do
        expect(UtilsDatetime::get_time_zone_offset("EST")).to eq(-5)
      end
    end
    context "when input is NOT valid" do
      it "raises an exception" do
        expect{ UtilsDatetime::get_time_zone_offset("not a time-zone") }.to raise_error(ArgumentError)
      end
    end
  end
end
