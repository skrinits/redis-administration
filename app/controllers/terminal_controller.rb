class TerminalController < ApplicationController
  def index
  end

  def show
    begin
      args = params[:command].split(' ')
      command = args.shift
      @response = redis.send command, *args
      if command == 'keys'
        render :show, layout: false
      else
        session[:db_index] = args[0] if command == 'select'
        render text: @response
      end
    rescue Exception => e  
      render text: e.message
    end    
  end
end
