$ ->

  widgets = $("@trove-widget[data-processed!='true']")

  if widgets.length > 0

    $(widgets).each (index) ->

      $(this).attr "data-processed", "true"
      type = $(this).data('type')
      if type == 'summary'
        ids = $(this).data("ids")
        action = (if ids.toString().split(',').length > 1 then 'multiple' else 'single')
        params = 'ids=' + ids

      src = '/widgets/' + type + '/' + action + '/?' + params
      $(this).after("<iframe src="+src+" scrolling='no' frameborder='0' style='border:none; width:305px; height:180px;' />")
