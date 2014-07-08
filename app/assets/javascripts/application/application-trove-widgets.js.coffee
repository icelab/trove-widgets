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
    enableFiltering                : true
    enableCaseInsensitiveFiltering : true
    numberDisplayed                : 1
    buttonWidth                    : '296px'

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
        new Trove.Views.Colorpicker()
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
      @.model.on('change:type change:ids change:state change:credits', @.setType, @)
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
            view: (if ids.toString().split(',').length > 1 then 'multiple' else 'single')
            height : 200
          else if (state != undefined && ids == undefined) || (state == undefined && ids == undefined)
            view : 'state'
            height : 184
          else if state != undefined && ids != undefined
            view : 'statesearch'
            height : 200
        else if type == 'navigator'
          view : 'title'
          height : 400

      options.height = options.height + 20 unless @.model.get('credits') == undefined || model.get('credits') == ''
      model.set options

  )

  #  Preview
  #  -----------------------------------------------

  Trove.Views.Preview = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['script'](root: @.model.get('root')))
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
      @.$el.html(JST['script'](root: @.model.get('root')))
      @

    generate: ->
      attributes = ''
      _(@.model.toJSON()).each (value, name) ->
        attributes += " data-" + name + "='" + value + "'" unless name == 'multiselect' || value == ''
      $('@script').html($('<div/>').text(@.render().$el.html().replace('div', 'div' + attributes)))
      #hljs.initHighlightingOnLoad()
      $('@script').each (i, e) ->
        hljs.highlightBlock e

  )

  #  Iframe
  #  -----------------------------------------------

  Trove.Views.Iframe = Backbone.View.extend(

    initialize: ->
      @.model.on('change', @.generate, @)

    render: ->
      @.$el.html(JST['iframe'](model: @.model.toJSON(), params: $.param(@.model.omit('root'))))
      @

    generate: ->
      $('@iframe').html($('<div/>').text(@.render().$el.html()))
      $('@iframe').each (i, e) ->
        hljs.highlightBlock e


  )

  #  Color picker
  #  -----------------------------------------------

  Trove.Views.Colorpicker = Backbone.View.extend(

    template:  (name) ->
      JST['colorpicker']({name: name, colors: ['FFFFFF', 'A9A9A9', '777777', 'CDCDCD', '000000', '939393', '333300', '000080', '333399', '333333', '800000', 'FF6600', '808000', '008000', '008080', '666699', '808080', 'FF0000', 'FF9900', 'FF9900', '99CC00', '339966', '339966', '33CCCC', '3366FF', '800080', '999999', 'FF00FF', 'FFCC00', 'FF0000', '00FF00', '00FFFF', '00CCFF', '993366', 'C0C0C0', 'FF99CC', 'FFCC99', 'FFFF99', 'CCFFFF']})

    initialize: ->
      _($('@configurator__pickable')).each $.proxy((el) ->
          @.render($(el))
      , @)

    render: (el) ->
      name = el.attr('name')
      role = 'configurator__pickable--' + name
      color = el.val()
      $(el).after(@.template(role))
      @.convert(role, name, color)

    convert: (role, name, color) ->
      $('@' + role).simplecolorpicker(
        picker: true
        theme: 'glyphicons'
      ).simplecolorpicker('selectColor', color).on 'change', ->
        $('input[name="'+name+'"]').val($('@' + role).val())

  )

  #
  #  |-----------------------------------------------
  #  | Models
  #  |-----------------------------------------------
  #

  Trove.Models.Widget = Backbone.Model.extend()
  Trove.Store.widgetModel = new Trove.Models.Widget(
    state      : 'nt'
    heading    : 'Digitised on Trove'
    background : '#FFFFFF'
    text       : '#777777'
    title      : '#333333'
    subtitle   : '#777777'
    border     : '#CDCDCD'
    width      : 300
    root       : $('@configurator').data('root')
  )

  #
  #  |-----------------------------------------------
  #  | Initialize
  #  |-----------------------------------------------
  #

  new Trove.Router()
  Backbone.history.start()
