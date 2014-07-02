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
          that.render(@, that.setOptions(@))


    # Parse and set data options
    setOptions: (el) ->

      options = $(el).data()
      $.extend options,
        width  : 300
        height : 180

      type = $(el).data('type')
      ids = $(el).data('ids')
      state = $(el).data('state')

      # Summary widget
      if type == 'summary'
        # Single and multiple newspapers summary
        if ids != undefined && state == undefined
          options.action = (if ids.toString().split(',').length > 1 then 'multiple' else 'single')
        # Particular state summary
        else if state != undefined && ids == undefined
          $.extend options,
            action : 'state'
            height : 164
        # State + newspapers search
        else if state != undefined && ids != undefined
          options.action = 'statesearch'
      # Navigator widget
      else if type == 'navigator'
        $.extend options,
          action : 'title'
          height : 400
      return options


    # Render iframe with options
    render: (el, options) ->

      src = '/widgets/' + options.type + '/' + options.action + '/?' + $.param(options)
      template = '<iframe src="'+src+'" scrolling="no" frameborder="0" style="border:none; width:'+options.width+'px; height:'+options.height+'px;" />'
      $(el).after(template)

) jQuery
