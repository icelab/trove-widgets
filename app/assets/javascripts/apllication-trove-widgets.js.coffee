window.TroveWidgets = {}

$ ->

  if $('@trove-widget__wrapper').length > 0
    TroveWidgets.inFrame.initialize()
  else
    TroveWidgets.inPage.initialize()
