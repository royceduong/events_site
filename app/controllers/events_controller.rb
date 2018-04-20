class EventsController < ApplicationController
    def index
        @user = User.find(session[:user_id])
        # @events_in_state = Event.where(state: "#{@user.state}")
        @events_in_state = Event.joins(:user).where(state: @user.state).select(:name, :date, :location, :state, :first_name, :user_id, :id)
        @events_out_state = Event.joins(:user).where.not(state: @user.state).select(:name, :date, :location, :state, :first_name, :user_id, :id)
        # @events_in_state = User.joins(:event).select(:name, :location, :)
    end
    def create
        @user = User.find(session[:user_id])
        @event = Event.new( name: params[:name], date: params[:date], location: params[:location], state: params[:state], user: @user )
        if @event.valid?
            puts "user id is..."
            puts @event.user_id
            @event.save
            flash[:messages] = ["#{@event.name}, has been added"]
        else
            flash[:messages] = @event.errors.full_messages
        end
        redirect_to "/events"
    end
    def edit
    end
    def destroy
        @event = Event.find(params[:id])
        @event.destroy
        flash[:messages] = ["Event Destroyed"]
        redirect_to "/events"
    end
    def join
        @user = current_user
        @event = Event.find(params[:id])
        puts "suhhh dude"
        puts params[:id]
        print @user
        print @event
        @sign = Signup.new(user: @user, event: @event)
        if @sign.valid?
            puts @sign.id
            @sign.save
            flash[:messages] = ["Joined #{@event.name}, bruh/bruh-dette"]
            redirect_to "/events"
        else
            flash[:messages] = @sign.errors.full_messages
            redirect_to "/events"
        end
        #what route is best for this? Should i make a attendees controller?
    end
    def cancel
        @user = current_user
        @event = Event.find(params[:id])
        anythingUwant = Signup.find_by(user: @user.id, event: @event.id)
        # Returns array.
        # how do i get the first thingy in the array.
        if anythingUwant.destroy
            flash[:messages] = ["You left the #{@event.name}"]
        else
            flash[:messages] = ["Didn't work, breh"]
        end
        redirect_to "/events"
    end
    def show
        @event = Event.find(params[:id])
        #how do I find the attendees?
        @guests = Signup.where(event: @event).joins(:user).select(:first_name, :location, :state)
        @count = @guests.length 
        @list = Signup.where(event: @event)
        @user = current_user
        @comments = Comment.joins(:user).where(event: @event).select(:first_name, :content)
        puts @comments
        # puts @list
        # @list.each do |guest_key|
        #     if guest_key.user_id == @user.id
        #         puts "hel yeah"
        #     else
        #         puts "fuck"
        #     end
        # end
        # @user = current_user.id
        # puts @user
        # if @list.user.include(@user)
        #     puts "wow, it works"
        # else    
        #     puts "not quite yet, more testing required"
        # end
    end
    def add_comment
        @user = current_user
        @event = Event.find(params[:id])
        @banana = Comment.new(content:params[:content], user:@user, event:@event)
        if @banana.valid?
            @banana.save
        else 
            flash[:messages] = @banana.errors.full_messages
        end
        redirect_to "/events/#{@event.id}"
    end
    private 
        # def event_params
        #     params.require(:event).permit(:name, :date, :location, :state, :current_user)
        # end
    
end
