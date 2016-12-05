class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    # Filter events based on in_time_zone date
    @date = DateTime.new(2016, 11, 29, 17, 30)
    @events_filtered = Event.get_after_date(@date)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event.rewind_datetime_for_editing
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save

        # Encode DateTime/TimeZone properly
        @event.start = UtilsDatetime::encode_for_time_zone(@event.start.to_datetime, @event.time_zone)
        @event.save

        format.html { redirect_to events_url, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)

        # Encode DateTime/TimeZone properly
        @event.start = UtilsDatetime::encode_for_time_zone(@event.start.to_datetime, @event.time_zone)
        @event.save

        format.html { redirect_to events_url, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # def getDateTimeFromUi(params)
    #   # parse out datetime object
    #   year = params[:event]['start(1i)'].to_i
    #   month = params[:event]['start(2i)'].to_i
    #   day = params[:event]['start(3i)'].to_i
    #   hour = params[:event]['start(4i)'].to_i
    #   minute = params[:event]['start(5i)'].to_i    
    #   startDate = DateTime.new(year, month, day, hour, minute)

    #   # sanitize params
    #   params[:event][:start] = parsed_time
    #   params[:event].delete 'start(1i)'
    #   params[:event].delete 'start(2i)'
    #   params[:event].delete 'start(3i)'
    #   params[:event].delete 'start(4i)'
    #   params[:event].delete 'start(5i)'
    # end


    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :start, :time_zone)
    end
end
