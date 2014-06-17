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

    options = {}
    type = options['type'] = $(el).data('type')
    options['width'] = 305
    options['height'] = 180
    if type == 'summary'
      ids = $(el).data("ids")
      if ids != undefined
        options['action'] = (if ids.toString().split(',').length > 1 then 'multiple' else 'single')
        options['params'] = 'ids=' + ids
      else
        options['height'] = 400
        options['action'] = 'state'
        options['params'] = 'state=' + $(el).data('state') + '&limit=' + $(el).data('limit')
    return options

  # Render iframe with options
  render: (el, options) ->

    src = '/widgets/' + options.type + '/' + options.action + '/?type=' + options.type + '&' + options.params
    template = '<iframe src="'+src+'" scrolling="no" frameborder="0" style="border:none; width:'+options.width+'px; height:'+options.height+'px;" />'
    $(el).after(template)
