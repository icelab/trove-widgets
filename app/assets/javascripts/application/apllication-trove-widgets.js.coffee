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
      new Trove.Views.Tabs({model: Trove.Store.widgetModel}) if type != model.get('type')
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
      this.model.on('change:type', this.setActive, this);
      return

    setActive: ->
      tabs = $('@nav')
      tabs.find('li').removeClass('active')
      tabs.find('[data-type='+this.model.get('type')+']').addClass('active')

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
