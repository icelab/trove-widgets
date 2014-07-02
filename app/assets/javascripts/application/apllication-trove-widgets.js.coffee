(->

  #
  #  |-----------------------------------------------
  #  | Properties
  #  |-----------------------------------------------
  #

  window.Trove =

    Models: {}
    Collections: {}
    Views: {}
    Router: {}
    Actions: {}
    Store: {}

)()


$ ->

  $('@configurator__ids-select').multiselect
    enableFiltering : true
    numberDisplayed : 1
    buttonWidth     : '296px'

  #
  #  |-----------------------------------------------
  #  | Routes
  #  |-----------------------------------------------
  #

  Trove.Router = Backbone.Router.extend(

    routes:
      '': 'widget'
      'types/:type': 'widget'

    widget: (type) ->
      type = 'summary' if type == null
      model = Trove.Store.widgetModel
      if model.get('type') == undefined
        options = {model: model}
        new Trove.Views.Tabs(options)
        new Trove.Views.Preview(options)
        new Trove.Views.Script(options)
        new Trove.Views.Iframe(options)
        new Trove.Views.Configurator(options)
      model.set(type: type)

  )

  #
  #  |-----------------------------------------------
  #  | Views
  #  |-----------------------------------------------
  #

  #  Tabs
  #  -----------------------------------------------

  Trove.Views.Tabs = Backbone.View.extend(

    initialize: ->
      @.model.on('change:type', @.setActive, @)

    setActive: ->
      tabs = $('@nav')
      tabs.find('li').removeClass('active')
      tabs.find('[data-type='+@.model.get('type')+']').addClass('active')

  )

  #  Configuration
  #  -----------------------------------------------

  Trove.Views.Configurator = Backbone.View.extend(

    el: '@configurator'

    events:
      'submit' : 'submit'

    initialize: ->
      @.model.on('change:type', @.selectorVisibility, @)
      @.model.on('change:type change:ids change:state', @.setType, @)
      Backbone.Syphon.deserialize(@, @.model.toJSON())

    submit: ->
      @.model.set(Backbone.Syphon.serialize(@))
      return false

    selectorVisibility: ->
      el = $('@configurator__ids')
      if @.model.get('type') == 'navigator'
        el.css('display', 'none')
        @.model.unset('ids')
      else
        el.css('display', 'block')

    setType: ->

      model = @.model
      type = model.get('type')
      state = model.get('state')
      state = undefined if state == 'any'
      ids = model.get('ids')
      ids = undefined if ids == '' || ids == ' ' || ids == null

      options =
        if type == 'summary'
          if ids != undefined && state == undefined
            action: (if ids.toString().split(',').length > 1 then 'multiple' else 'single')
            height : 180
          else if (state != undefined && ids == undefined) || (state == undefined && ids == undefined)
            action : 'state'
            height : 164
          else if state != undefined && ids != undefined
            action : 'statesearch'
            height : 180
        else if type == 'navigator'
          action : 'title'
          height : 400

      model.set options

  )

  #  Preview
  #  -----------------------------------------------

  Trove.Views.Preview = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['script']())
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == ''
      $('@preview').html(@.render().$el.html().replace('div', 'div' + attributes))

  )

  #  Script
  #  -----------------------------------------------

  Trove.Views.Script = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['script']())
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == ''
      $('@script').html($('<div/>').text(@.render().$el.html().replace('div', 'div' + attributes)))
      prettyPrint()

  )

  #  Iframe
  #  -----------------------------------------------

  Trove.Views.Iframe = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['iframe'](model: @.model.toJSON(), params: $.param(@.model.toJSON())))
      @

    generate: ->
      $('@iframe').html($('<div/>').text(@.render().$el.html()))
      prettyPrint()

  )

  #
  #  |-----------------------------------------------
  #  | Models
  #  |-----------------------------------------------
  #

  Trove.Models.Widget = Backbone.Model.extend()
  Trove.Store.widgetModel = new Trove.Models.Widget(
    state      : 'tas'
    background : '#FFFFFF'
    text       : '#A9A9A9'
    title      : '#666666'
    subtitle   : '#CDCDCD'
    border     : '#CDCDCD'
    width      : 300
  )

  #
  #  |-----------------------------------------------
  #  | Initialize
  #  |-----------------------------------------------
  #

  new Trove.Router()
  Backbone.history.start()
