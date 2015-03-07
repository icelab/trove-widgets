jQuery.noConflict()
(($) ->

  window.TroveWidgets.inFrame =


    initialize: (el) ->

      # Load children pages
      that = @
      $('@trove-widget__preload').load el.data('root') + 'widgets/' + el.data('type') + '/' + el.data('view') + '?' + $.param(el.data()), ->
        el.css('background', 'none')
        namespace = that[el.data('type') + '_' + el.data('view')]
        namespace.initialize() if typeof(namespace) != 'undefined'


    common:

      reshuffle:

        initialize: () ->

          # Pick all newspaper items
          @.items = $('@summary__item')
          if @.items.length > 1
            # Find max item height and set that height for all items
            #setInterval $.proxy(@.setHeight, @), 500
            @.setHeight()
            # Start auto scrolling
            @.timerId = setInterval $.proxy(@.autoScroll, @), 5000
            # Attach event for manual scrolling
            @.arrows = $('@summary__arrows').find('i')
            @.arrows.on 'click', $.proxy((e) ->
              # Stop auto scrolling
              clearInterval(@.timerId)
              # Continue scroll manually to selected item
              current = $(e.currentTarget)
              @.manualScroll(current.attr('data-target'))
            , @)
            # Stop auto scrolling after input focusing
            $('input').on 'focus', $.proxy((e) ->
              clearInterval(@.timerId)
            , @)

        setHeight: () ->
          # Only for unprocessed items
          while @.items.filter("[data-height='auto']").length > 0
            parent = @.items.first().parent()
            heights = @.items.map(->
              $(@).height()
            ).get()
            maxHeight = Math.max.apply(null, heights)
            parentHeight = parent.height()
            maxHeight = parentHeight if maxHeight < parentHeight
            $.each @.items, () ->
              $(@).css('height', maxHeight)
              $(@).attr('data-height', 'manual')

        autoScroll: () ->
          @.manualScroll(@.arrows.last().attr('data-target'))

        manualScroll: (targetId) ->
          currentTarget = @.items.filter("[data-target="+targetId+"]")
          @.items.first().animate({'margin-top': -(currentTarget.index())*currentTarget.height()}, 500, 'linear')
          prevTarget = (if currentTarget.prev().length is 0 then @.items.last() else currentTarget.prev()).data('target')
          nextTarget = (if currentTarget.next().attr('role') != 'summary__item' then @.items.first() else currentTarget.next()).data('target')
          @.arrows.filter("[data-direction='up']").attr('data-target', prevTarget)
          @.arrows.filter("[data-direction='down']").attr('data-target', nextTarget)

    summary_multiple:

      initialize: ->
        TroveWidgets.inFrame.common.reshuffle.initialize();


    summary_statesearch:

      initialize: ->
        TroveWidgets.inFrame.common.reshuffle.initialize();


    navigator_title:

      initialize: ->

        $('@navigator__search').fastLiveFilter('@navigator__list')

        $('@navigator__stats').find('i').on 'click', $.proxy((e) ->
          @.dateFilter(e.currentTarget)
        , @)

      dateFilter: (el) ->
        type = $(el).data('type')
        items = $('@navigator__list').find('li')
        dates = []
        $.each items, () ->
          dates.push $(@).data(type)
        @.createList(el, $.unique dates.sort())

      createList: (el, years) ->
        type = $(el).data('type')
        select = '<select>'
        $.each years, (index, value) ->
          select += '<option value=' + value.toString() + '>' + value.toString() + '</option>' if value > 0
        select += '</select>'
        selectElement = $.parseHTML(select)
        $(selectElement).val($(el).text())
        $(el).replaceWith(selectElement)
        $(selectElement).on 'change', $.proxy((e) ->
          @.setFilter(e, type)
          @.filtering()
        , @)

      setFilter: (e, type) ->
        selectedYear = $(e.currentTarget).find(':selected').val()
        $('@navigator__list').data(type, selectedYear)

      filtering: () ->
        parent = $('@navigator__list')
        items = parent.find('li')
        params = parent.data()
        counter = 0
        $.each items, () ->
          if $(@).data('start') >= params.start && $(@).data('end') <= params.end
            $(@).fadeIn()
            counter++
          else
            $(@).fadeOut()
        $('@navigator__counter').text(counter)

    usage_multiple:

      initialize: ->
        TroveWidgets.inFrame.common.reshuffle.initialize();

) jQuery
