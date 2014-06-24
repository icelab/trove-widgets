window.TroveWidgets.inFrame =


  initialize: (el) ->

    # Call iframe related method
    method = @[el.data('type') + '_' + el.data('action')]
    method() if typeof(method) != 'undefined'


  summary_multiple: () ->

    timerId = setInterval (->
      items = $('@summary__item')
      current = items.filter("[data-type='active']")
      next = (if current.next().length is 0 then items.first() else current.next())
      current.attr('data-type', 'normal')
      next.attr('data-type', 'active')
      items.first().animate({'margin-top': -(current.index())*134}, 500, 'linear')
    ), 5000

    $('input').focus ->
      clearInterval(timerId)


  summary_state: () ->
    $('@search__field').fastLiveFilter('@summary-state__list')
