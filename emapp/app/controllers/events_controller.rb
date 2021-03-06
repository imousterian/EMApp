class EventsController < ApplicationController
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    before_action :find_correct_event, only: [:join, :accept_request, :reject_request]
    before_action :event_owner!, only: [:edit, :update, :destroy]
    before_filter :authenticate_user!, except:[:index, :show]
    respond_to :html, :js

  # GET /events
  # GET /events.json
    def index
        if params[:tag]
            @events = Event.tagged_with(params[:tag])
        else
            @events = Event.all
        end
    end

    def join
        if current_user.id != @event.organizer_id
            @attendance = Attendance.join_event(current_user.id, params[:event_id], 'request_sent')
            respond_to do |format|
                format.html { redirect_to @event, :notice => 'Thanks! We will notify you.' }
            end
        else
            respond_to do |format|
                format.html { redirect_to root_url, :notice => 'You can not join your own event.' }
            end
        end
    end

    def accept_request

        @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
        @attendance.accept!
        respond_to do |format|
            if @attendance.save
                format.html { redirect_to @event, :notice => 'Accepted!' }
            end
        end
    end

    def reject_request
        @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
        @attendance.reject!
        respond_to do |format|
            if @attendance.save
                format.html { redirect_to @event, :notice => 'Rejected!' }
            end
        end
    end

  # GET /events/1
  # GET /events/1.json
    def show
        @event_owner = @event.organizer
        @attendees = @event.show_accepted_attendees(@event.id)
    end

  # GET /events/new
    def new
        @event = current_user.organized_events.build
    end

  # GET /events/1/edit
    def edit
    end

  # POST /events
  # POST /events.json
    def create
        @event = current_user.organized_events.build(event_params)

        respond_to do |format|
        if @event.save
            format.html { redirect_to @event, notice: 'Event was successfully created.' }
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
            format.html { redirect_to @event, notice: 'Event was successfully updated.' }
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

    def my_events
        @events = current_user.organized_events
    end

    private
    # Use callbacks to share common setup or constraints between actions.
        def set_event
          @event = Event.friendly.find(params[:id])
        end

        def find_correct_event
            @event = Event.friendly.find_by(:id => params[:event_id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def event_params
          params.require(:event).permit(:title, :start_date, :end_date, :location, :agenda, :address, :all_tags)
        end

        def event_owner!
            authenticate_user!
            if @event.organizer_id != current_user.id
                redirect_to root_url
                flash[:alert] = 'You do not have permissions to do this.'
            end
        end
end
