//= require tree.jquery
//= require messager

$(->        
        #variables
        $editKeyArea = $('#edit-key-area')
        $nameKey = $('#editor_key #key-name')
        #functions        
        getKey = (node) ->
            level =  node.getLevel()
            parts = []
            parent = null
            for i in [1..level]
                parent = unless parent then node else parent.parent
                parts.unshift(parent.name)
            key = parts.join(':')
            return key

        setKeyContent = (key) ->
            content = ''
            $.ajax({
                url: '/key/content?key=' + encodeURIComponent(key),
                type: 'GET',
                success: (data)->
                    $editKeyArea.val(data)
                    return
            })
            return

        refreshEditorKey  = (node, root = false, subRoot = false) ->
            key = getKey(node)
            $nameKey.val(key)
            setKeyContent(key)

            unless root
                # for button in [$editButton, $deleteButton, $addButton]
                #     button.css('display', 'inline-block')
                # for element in [$saveButton, $cancelButton, $nameKey]
                #     element.css('display', 'none')
                $editKeyArea.css('display', 'block').attr('disabled', 'disabled')
                $deleteButton.css('display', 'inline-block')
            else
                # for element in [$saveButton, $cancelButton, $nameKey, $editButton, $addButton, $editKeyArea]
                #     element.css('display', 'none')
                $editKeyArea.css('display', 'none')
                $deleteButton.css('display', 'none')
            return 

        bindEvents = ->
            $keysTree.bind( 'tree.select', (event)->
                node = event.node
                # $keysTree.tree('selectNode', null);
                # $keysTree.tree('selectNode', node);
                if  node
                    if  node.isFolder()    
                        level =  node.getLevel()
                        if level == 1
                            $('#editor_key').css('visibility', 'visible')
                            refreshEditorKey(node, true)
                        else
                            $('#editor_key').css('visibility', 'hidden')
                    else
                        $('#editor_key').css('visibility', 'visible')
                        refreshEditorKey(node)                        
                else
                    $('#editor_key').css('visibility', 'hidden')
                 return
            )
            $keysTree.bind( 'tree.open', (event)->
                node = event.node
                $('#editor_key').css('visibility', 'hidden')
                if node.children.length == 0
                    key = getKey(node)
                    $.getJSON('/keys?key=' + key, (data)->
                           $keysTree.tree('loadData', data, node);
                    )
            )

            $keysTree.bind( 'tree.close', (event)->
                $keysTree.tree('selectNode', null);
                $('#editor_key').css('visibility', 'hidden') 
            )

            $keysTree.bind('tree.contextmenu', (event)->
                return   
            )
            return

        $keysTree = $('#keys_tree')
        $keysTree.tree({
            dataUrl: '/keys',
        }) 

        bindEvents()

        $('#select-db select').change (e)->
            db_id = $('option:selected', $(this)).val()
            $keysTree.tree('destroy')
            $keysTree.tree({
                dataUrl: '/keys?db_id=' + db_id,
            }) 
            bindEvents()
            return
        
        $('#select-db a.btn.btn-danger').click ->
            db_id = $('#select-db select option:selected').val()
            $.ajax({
                url: '/keys/flushdb/' +  db_id,
                type: 'DELETE',
                success: ->
                    messager.showSuccess('Successfully flush db')
                error: (xhr, textStatus, errorThrown) ->
                    messager.showError(errorThrown)
            })
            $keysTree.tree('destroy')            
            return false

        #buttons
        $editButton =  $('#editor_key a[title="Edit"]')
        $saveButton = $('#editor_key a[title="Save"]')
        $deleteButton = $('#editor_key a[title="Delete"]')
        $addButton = $('#editor_key a[title="Add New Key"]')
        $cancelButton =$('#editor_key a[title="Cancel"]')

        #temprorary hidden: future release
        for button in [$editButton, $addButton]
            button.css('display', 'none')

        $nameKey.css('display', 'none')

        $addButton.click ->
            $nameKey.css('display', 'block')
            $editKeyArea.attr('disabled', false)
            for button in [$saveButton, $cancelButton]
                button.css('display', 'inline-block')
            for button in [$(this), $deleteButton, $editButton]
                button.css('display', 'none')
            return false

        $cancelButton.click ->
            node = $keysTree.tree('getSelectedNode')
            refreshEditorKey(node)
            return false

        $editButton.click ->
            button.css('display', 'inline-block') for button in [$saveButton, $cancelButton]
            $(this).css('display', 'none')            
            $nameKey.css('display', 'block')
            $editKeyArea.attr('disabled', false)
            node = $keysTree.tree('getSelectedNode')
            key = getKey(node)
            $nameKey.val(key) 
            $editKeyArea.val(setKeyContent(key))          
            return false;

        $deleteButton.click ->
            response = confirm('Are you sure?')
            node = $keysTree.tree('getSelectedNode')
            if response
                node = $keysTree.tree('getSelectedNode')
                $.ajax({
                    url: '/keys/del?key=' +  getKey(node),
                    type: 'DELETE',
                    success: ->
                        messager.showSuccess('Successfully deleted key')
                        $keysTree.tree('removeNode', node);
                        $editKeyArea.css('display', 'none')
                        $deleteButton.css('display', 'none')
                    error: (xhr, textStatus, errorThrown) ->
                        messager.showError(errorThrown)
                })

            return false;
        
        $saveButton.click ->
            node = $keysTree.tree('getSelectedNode')
            refreshEditorKey(node)
            return false;

        #default no display
        $saveButton.css('display', 'none')
        $cancelButton.css('display', 'none')


        #edit block initialization
        $('#editor_key').portamento()  if $('#editor_key').length > 0

        return
)