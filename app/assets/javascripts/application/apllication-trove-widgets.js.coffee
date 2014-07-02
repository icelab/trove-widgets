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

  $('@configurator__ids-select').multiselect({enableFiltering: true, numberDisplayed: 1, buttonWidth: '296px'})

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
        new Trove.Views.Tabs({model: model})
        new Trove.Views.Preview({model: model})
        new Trove.Views.Code({model: model})
        new Trove.Views.Configurator({model: model})
      model.set({type: type})

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

  #  Preview
  #  -----------------------------------------------

  Trove.Views.Preview = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['widget'](@.model.toJSON()))
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == '' || value == null || value == 'any'
      $('@preview').html(@.render().$el.html().replace('script', 'script' + attributes))

  )

  #  Code
  #  -----------------------------------------------

  Trove.Views.Code = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['widget'](@.model.toJSON()))
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == '' || value == null || value == 'any'
      $('@code').html($('<div/>').text(@.render().$el.html().replace('script', 'script' + attributes)))

  )

  #  Configuration
  #  -----------------------------------------------

  Trove.Views.Configurator = Backbone.View.extend(

    el: '@configurator'

    events:
      'submit' : 'submit'

    initialize: ->
      @.model.on('change:type', @.selectorVisibility, @)
      Backbone.Syphon.deserialize(@, @.model.toJSON())

    submit: ->
      @.model.set(Backbone.Syphon.serialize(@))
      return false

    selectorVisibility: ->
      el = $('@configurator__ids')
      if @.model.get('type') == 'navigator'
        el.css('display', 'none')
        @.model.set('ids', '')
      else
        el.css('display', 'block')

  )


  #
  #  |-----------------------------------------------
  #  | Models
  #  |-----------------------------------------------
  #

  Trove.Models.Widget = Backbone.Model.extend()
  Trove.Store.widgetModel = new Trove.Models.Widget({
    state      : 'tas'
    background : '#FFFFFF'
    text       : '#A9A9A9'
    title      : '#666666'
    subtitle   : '#CDCDCD'
    border     : '#CDCDCD'
  })

  #
  #  |-----------------------------------------------
  #  | Initialize
  #  |-----------------------------------------------
  #

  new Trove.Router()
  Backbone.history.start()
