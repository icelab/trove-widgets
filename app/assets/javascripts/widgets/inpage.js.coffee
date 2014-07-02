jQuery.noConflict()
(($) ->


  window.TroveWidgets.inPage =

    initialize: ->

      @.process()


    # Process unprocessed script elements
    process: ->

      widgets = $("@trove-widget[data-processed!='true']")
      if widgets.length > 0
        that = @
        $(widgets).each (index) ->
          $(@).attr "data-processed", "true"
          that.render(@, $(@).data())


    # Render iframe with options
    render: (el, options) ->

      src = '/widgets/' + options.type + '/' + options.action + '/?' + $.param(options)
      template = '<iframe src="'+src+'" scrolling="no" frameborder="0" style="border:none; width:'+options.width+'px; height:'+options.height+'px;" />'
      $(el).after(template)


) jQuery
