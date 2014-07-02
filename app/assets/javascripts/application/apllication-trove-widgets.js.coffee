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

  $('.builder__titles').multiselect({enableFiltering: true, numberDisplayed: 1, buttonWidth: '296px'})

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
      unless type == model.get('type')
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
      @.model.on('change:type', @.setActive, @);

    setActive: ->
      tabs = $('@nav')
      tabs.find('li').removeClass('active')
      tabs.find('[data-type='+@.model.get('type')+']').addClass('active')

  )

  #  Preview
  #  -----------------------------------------------

  Trove.Views.Preview = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @);

    render: ->
      @.$el.html(JST['widget'](@.model.toJSON()))
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == '' || value == null || value == 'all'
      $('@preview').html(@.render().$el.html().replace('script', 'script' + attributes))

  )

  #  Code
  #  -----------------------------------------------

  Trove.Views.Code = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @);

    render: ->
      @.$el.html(JST['widget'](@.model.toJSON()))
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == '' || value == null || value == 'all'
      $('@code').html($('<div/>').text(@.render().$el.html().replace('script', 'script' + attributes)))

  )

  #  Configuration
  #  -----------------------------------------------

  Trove.Views.Configurator = Backbone.View.extend(

    el: '@configurator'

    events:
      'submit' : 'submit'

    initialize: ->

    submit: ->
      @.model.set(Backbone.Syphon.serialize(@))
      return false

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
    border     : '#CDCDCD'
  })

  #
  #  |-----------------------------------------------
  #  | Initialize
  #  |-----------------------------------------------
  #

  new Trove.Router()
  Backbone.history.start()
