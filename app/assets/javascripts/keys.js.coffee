$(->
  $selectDb = $('#select-db')
  $selectDb.find('select').on('change', ->
    db = $(this).find(':selected').val() 
    $.ajax({
      url: "/keys?db_id=#{db}",
      dataType: 'json',
      success: (data)->
        messager.showSuccess("Db '#{db}' has been selected")
        return
      error: (xhr, textStatus, errorThrown)->
        messager.showError(textStatus)
        return
    })
    return false
  )
  $selectDb.find('a').click ->
    confirmation = confirm('Flush database, are you sure?')
    if confirmation
      $.ajax({
        url: '/keys/destroy/flushdb',
        type: 'DELETE',
        dataType: 'text',
        success: (data)->
          messager.showSuccess(data)
          return
        error: (xhr, textStatus, errorThrown)->
          messager.showError(textStatus)
          return
      })
    return false

  $('#tree').tree('/keys')
  return
)