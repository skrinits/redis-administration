$(->
    $(".editable").editable("/configuration", { 
        indicator : "<img src='/assets/jeditable/indicator.gif'>",
        submit: 'OK',
        cancel: 'Cancel',
        tooltip: "Click to edit...",
        submitdata: (value, settings) ->
                        param = $.trim($(this).siblings('td').text())
                        return { _method: "patch", param: param}
                        
        onerror: ()->
                            messager.showError('Error')
                            return
                        
        callback: (obj, result)->
                            jsonResult = $.parseJSON(result)
                            obj.html(jsonResult.value);
                            if jsonResult.notice
                                messager.showSuccess(jsonResult.notice)
                            else
                                $(this).text('')
                                messager.showError(jsonResult.error)
                            return

    })
    return 
)

