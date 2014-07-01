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
      console.debug(type)
      return
  )

  #
  #  |-----------------------------------------------
  #  | Initialize
  #  |-----------------------------------------------
  #

  new Trove.Router()
  Backbone.history.start()
