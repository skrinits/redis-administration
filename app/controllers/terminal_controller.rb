class TerminalController < ApplicationController
    def index
    end

    def show
        args = params[:command].split(' ')
        command = args.shift
        @response = redis.send command, *args
        if command =~ /keys/
            render :show, layout: false
        else
            render text: @response
        end    
    end
end
