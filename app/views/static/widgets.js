<%== Rails.application.assets.find_asset('application').to_s %>

$(function() {
  var widgets = $("@trove-widget[data-processed!='true']")
  if (widgets.length > 0) {
    $(widgets).each(function(index) {
      $(this).attr('data-processed', 'true')

      var ids = $(this).data('ids');
      var action = ids.toString().split(',').length > 1 ? 'multiple': 'single';
      $(this).after('<iframe src="widgets/'+$(this).data('type')+'/'+action+'.html?ids='+ids+'" scrolling="no" frameborder="0" style="border:none;width:305px;height:180px;" />')

    });
  }
});
