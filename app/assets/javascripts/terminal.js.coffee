$( ->        
        if $('#terminal').length > 0
            $('#terminal').terminal( 
                (command, term) -> 
                    if command == 'reset'
                        term.clear()
                        return
                    $.ajax({
                          type: "GET",
                          url: "/terminal/command",
                          data: {command: command}
                          success: (data, textStatus, xhr) ->
                                term.echo(data, {raw: true})
                                return
                          error: (xhr, textStatus, errorThrown) ->
                                messager.showError(errorThrown)
                                term.error(errorThrown)
                                return 
                    }) 
                    return               
                {
                    greetings: '',
                    height: 400,
                    prompt: '$>'
                })

        return
)