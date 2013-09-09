class StatusController < ApplicationController
  def show
    # Could optimize this by just doing one query and splitting the result, but
    # went for TDDability and isolation here, this would also be ideal if we wanted
    # to dedupe (as in, not show the current status in the history)
    @current_status = Status.current
    @status_history = Status.history
  end
  
  def update
    begin
      result = Status.publish(params[:status])
      render :text => "#{result.code}: #{result.message || '(No message provided)'}"
    rescue ArgumentError => e
      render :text => "#{e.message}", :status => :bad_request
    end
  end
end
