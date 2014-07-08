jQuery.noConflict()
(($) ->

  window.TroveWidgets = {}

  $ ->

    wrapper = $('@trove-widget__wrapper')

    # Script called in frame
    if wrapper.length > 0
      TroveWidgets.inFrame.initialize(wrapper)
    # Script embedded on page
    else
      TroveWidgets.onPage.initialize()

) jQuery
