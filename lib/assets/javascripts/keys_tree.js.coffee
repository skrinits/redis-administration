do($=jQuery) -> 
  $.fn.tree = (url)->    
    $selectedNode = null
    $editForm = $('#edit-key')

    $editForm.click (e)->
      switch e.target.id
        when 'close'
          unselect()
        when 'delete'
          key = $editForm.find('#key-name').val()
          $.ajax({
            url: "/keys/destroy/key/#{key}",
            type: 'DELETE',
            success: (data, textStatus, xhr)->
              $selectedNode.hide()
              $editForm.hide()
              messager.showSuccess(data)
              return
            error: (xhr, errorStatus, errorThrown)->
              messager.showError(errorStatus)
              return          
          })
        when 'submit'
          $.ajax({
            url: "/keys/#{$editForm.find('#key-name').val()}",
            data: {content: $editForm.find('#edit-key-area').val(), type: $editForm.find('#type').val()},
            type: 'PUT',
            success: (data, textStatus, xhr)->
              unselect()
              if data.success
                messager.showSuccess(data.success)
              else
                messager.showError(data.error)
              return
            error: (xhr, errorStatus, errorThrown)->
              messager.showError(errorStatus)
              return   
          })
      return false    

    unselect = ->
      $selectedNode.find('.Content').removeClass('Select') 
      $selectedNode = null
      $editForm.hide()
    
    show = (node)->
      $content = node.find('.Content')
      $selectedNode = node      
      $content = $selectedNode.find('.Content').addClass('Select')
      offset = $content.offset()
      $editForm.css({top: offset.top + 'px', left: (offset.left + $content.outerWidth() + 5) + 'px'}).show()
      $editForm.find('#key-name').val(node.data('id'))

      $.ajax({
        url: "/keys/#{node.data('id')}",
        dataType: 'json',
        success: (data, textStatus, xhr)->
          $editForm.find('#edit-key-area').val(data.content)
          $editForm.find('#type').val(data.type)
          $editForm.find('#type-key span b').text(data.type.toUpperCase())
          return
        error: (xhr, errorStatus, errorThrown)->
          console.log errorStatus
          return
      })
      return

    toggleNode = (node)->
      node.toggleClass('ExpandOpen ExpandClosed')

    load = (node)->
      showLoading = ->
        node.children('div').eq(0).toggleClass("Expand ExpandLoading")
        return

      onLoaded = (data)->
        for child in data
          li = $('<li></li>')
          li.data('id', child.id)
          title = child.id.split(':').pop()

          li.addClass("Node Expand" + (if child.isParent then 'Closed' else 'Leaf'))
          li.addClass('IsLast') if child == data[data.length-1] 

          innerHTML = '<div class="Expand"></div><div class="Content">' + title + '</div>'
          innerHTML += '<ul class="Container"></ul>' if child.isParent  
          li.html(innerHTML)

          node.find('ul').eq(0).append(li)
        node.data('isLoaded', true)
        toggleNode(node)
        return

      showLoading(true)

      $.ajax({
        url: url,
        data: {id: node.data('id')},
        dataType: "json",
        success: (data, textStatus, xhr)->
          onLoaded(data)
          showLoading(false)
          return      
        error: (xhr, errorStatus, errorThrown)->
          console.log errorStatus
          return
        cache: false
      })

    this.click (e)->
      clickedElem = $(e.target)
      node = clickedElem.parent()

      if $selectedNode          
        $selectedNode.find('.Content').removeClass('Select') 
        $editForm.hide()
        theSame = $selectedNode == node
        $selectedNode = null
        return if theSame 
      
      return if !(clickedElem.hasClass('Content') || clickedElem.hasClass('Expand'))

      if node.hasClass('ExpandLeaf')         
        show(node)
        return

      if node.data('isLoaded') || node.children('li').length
        toggleNode(node)
        return

      load(node)
      return