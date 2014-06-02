
class Messager    
    # private
    getView =   (message, view_class) ->
        view  = "<div class='" + view_class + "'>" + message + "</div>"
        return view

    showSuccess: (message) ->
        html = getView(message, 'alert alert-success span7 offset2 flash-message')
        $('body').find('.flash-message').hide()
        $('body').prepend(html)
        $alert = $('.alert')
        $alert.fadeOut(5000, ->
            $(this).remove()
            return
        )       
        return

    showError: (message) ->
        html = getView(message, 'alert alert-error span7 offset2 flash-message')
        $('body').find('.flash-message').hide()
        $('body').prepend(html)
        $alert = $('.alert')
        $alert.fadeOut(10000, ->
            $(this).remove()
            return
        )    
        return
        
@messager = new Messager