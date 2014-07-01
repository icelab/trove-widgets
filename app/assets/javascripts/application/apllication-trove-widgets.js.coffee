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
      '': 'index'
      'types/:type': 'index'

    index: (type) ->
      type = 'summary' if type == null
      model = Trove.Store.widgetModel
      if type != model.get('type')
        new Trove.Views.Tabs({model: model})
        new Trove.Views.Preview({mode: model})
        new Trove.Views.Code({mode: model})
      model.set({type: type})

  )

  #
  #  |-----------------------------------------------
  #  | Views
  #  |-----------------------------------------------
  #

  # Tabs
  #    -----------------------------------------------

  Trove.Views.Tabs = Backbone.View.extend(

    initialize: ->
      @.model.on('change:type', @.setActive, @);
      return

    setActive: ->
      tabs = $('@nav')
      tabs.find('li').removeClass('active')
      tabs.find('[data-type='+@.model.get('type')+']').addClass('active')

  )

  # Preview
  #    -----------------------------------------------

  Trove.Views.Preview = Backbone.View.extend(

    template : JST['widget']({world: "World"})

    initialize: ->
      $('@preview').html(@.render().el)

    render: ->
      @.$el.append(@.template)
      @

  )

  # Code
  #    -----------------------------------------------

  Trove.Views.Code = Backbone.View.extend(

    template : JST['widget']({world: "World"})

    initialize: ->
      $('@code').html($('<div/>').text(@.render().$el.html()).html())

    render: ->
      @.$el.append(@.template)
      @

  )

  #
  #  |-----------------------------------------------
  #  | Models
  #  |-----------------------------------------------
  #

  Trove.Models.Widget = Backbone.Model.extend()
  Trove.Store.widgetModel = new Trove.Models.Widget({
    state      : 'any'
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
