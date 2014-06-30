window.TroveWidgets = {}

$ ->

  wrapper = $('@trove-widget__wrapper')

  if wrapper.length > 0
    TroveWidgets.inFrame.initialize(wrapper)
  else
    TroveWidgets.inPage.initialize()
