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
    if type == 'summary'
      ids = $(el).data("ids")
      options['action'] = (if ids.toString().split(',').length > 1 then 'multiple' else 'single')
      options['params'] = 'ids=' + ids
    return options

  # Render iframe with options
  render: (el, options) ->

    src = '/widgets/' + options.type + '/' + options.action + '/?type=' + options.type + '&' + options.params
    $(el).after("<iframe src=" + src + " scrolling='no' frameborder='0' style='border:none; width:305px; height:180px;' />")
