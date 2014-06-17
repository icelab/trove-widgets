<%== Rails.application.assets.find_asset('application').to_s %>

$(function() {
  var widgets = $("@trove-widget[data-processed!='true']")
  if (widgets.length > 0) {
    $(widgets).each(function(index) {
      $(this).attr('data-processed', 'true')
      $(this).after('<iframe src="widgets/<%= params[:type] =%>.html?titles='+$(this).data('titles')+'" scrolling="no" frameborder="0" style="border:none;width:305px;height:180px;" />')
    });
  }
});
