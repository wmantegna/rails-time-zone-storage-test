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

  describe '.handle_daylight_savings(time)' do

    #    time_to_check |     time.now    | outcome
    #   --------------------------------------
    #   during_dst     | during_dst      | + 1 hour
    #   during_dst     | not_during_dst  | - 1 hour
    #   not_during_dst | during_dst      | same
    #   not_during_dst | not_during_dst  | same

    
    let (:during_dst) { Time.new(2017, 3, 12, 12)}
    let (:not_during_dst) { Time.new(2017, 3, 11, 12)}

    context 'During Daylight Savings' do
      before do
        Timecop.travel(during_dst)
      end
      after do
        Timecop.return
      end

      it 'springs forward' do
        expected = during_dst + 1.hour
        actual = UtilsDatetime::handle_daylight_savings(during_dst)

        expect(actual).to eq(expected)
      end
      it 'doesn\'t spring forward' do
        expected = not_during_dst
        actual = UtilsDatetime::handle_daylight_savings(not_during_dst)

        expect(actual).to eq(expected)
      end
    end
    context 'not during Daylight Savings' do
      before do
        Timecop.travel(not_during_dst)
      end
      after do
        Timecop.return
      end

      it 'falls back' do
        expected = during_dst - 1.hour
        actual = UtilsDatetime::handle_daylight_savings(during_dst)

        expect(actual).to eq(expected)
      end
      it 'doesn\'t fall back' do
        expected = not_during_dst
        actual = UtilsDatetime::handle_daylight_savings(not_during_dst)

        expect(actual).to eq(expected)
      end
    end
  end

  describe '.replace_dst_time_zone_names()' do
    def self.it_replaces(dst_name, with: non_dst_name)
      it "it replaces #{dst_name} with #{with}" do

        date_str = "2017-03-13 12:00 #{dst_name}"
        replaced_str = UtilsDatetime::replace_dst_time_zone_names(date_str)

        expect(replaced_str.index(dst_name)).to eq(nil)
        expect(replaced_str.index(with)).to be > -1
      end
    end

    it_replaces 'EDT', with: 'EST'
    it_replaces 'CDT', with: 'CST'
    it_replaces 'MDT', with: 'MST'
    it_replaces 'PDT', with: 'PST'
  end
end
