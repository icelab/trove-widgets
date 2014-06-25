window.TroveWidgets.inFrame =


  initialize: (el) ->

    # Call iframe related method
    method = @[el.data('type') + '_' + el.data('action')]
    method() if typeof(method) != 'undefined'


  summary_multiple: () ->

    TroveWidgets.inFrame.reshuffle();


  summary_statesearch: () ->

    TroveWidgets.inFrame.reshuffle();


  navigator_title: () ->
    $('@search__field').fastLiveFilter('@summary-state__list')


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
