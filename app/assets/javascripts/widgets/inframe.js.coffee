jQuery.noConflict()
(($) ->

  window.TroveWidgets.inFrame =


    initialize: (el) ->

      # Call iframe related namaspace
      namaspace = @[el.data('type') + '_' + el.data('action')]
      namaspace.initialize() if typeof(namaspace) != 'undefined'


    common:

      reshuffle: () ->

        timerId = setInterval (->
          items = $('@summary__item')
          current = items.filter("[data-type='active']")
          next = (if current.next().length is 0 then items.first() else current.next())
          current.attr('data-type', 'normal')
          next.attr('data-type', 'active')
          items.first().animate({'margin-top': -(current.index())*current.height()}, 500, 'linear')
        ), 5000

        $('input').focus ->
          clearInterval(timerId)


    summary_multiple:

      initialize: ->
        TroveWidgets.inFrame.common.reshuffle();


    summary_statesearch:

      initialize: ->
        TroveWidgets.inFrame.common.reshuffle();


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
          select += '<option value=' + value.toString() + '>' + value.toString() + '</option>'
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

) jQuery
