
class Messager    
    # private
    getView =   (message, view_class) ->
        style = "position:absolute;text-align:center;z-index: 99;margin-top: 5px; opacity: 0.9;"
        view  = "<div class='" + view_class + "' style='" + style + "'>" + message + "</div>"
        return view

    showSuccess: (message) ->
        html = getView(message, 'alert alert-success span7 offset2')
        $('body').prepend(html)
        $alert = $('.alert')
        $alert.fadeOut(2000, ->
            $(this).remove()
            return
        )       
        return

    showError: (message) ->
        html = getView(message, 'alert alert-error span7 offset2')
        $('body').prepend(html)
        $alert = $('.alert')
        $alert.fadeOut(10000, ->
            $(this).remove()
            return
        )    
        return
        
@messager = new Messager