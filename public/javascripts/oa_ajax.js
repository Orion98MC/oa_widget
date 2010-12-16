// Patch links and forms with "ajax" class to be ajax calls
jQuery(function(){
	jQuery('a.ajax_rel, input.ajax_rel').live("click", function() { jQuery.get(this.href + heartbeat_serialize(jQuery(this).attr("rel")), null, null, "script"); return false;});	
  jQuery('a.ajax, input.ajax, div.pagination>a').live("click", function() { jQuery.get(this.href, null, null, "script");return false; });
  jQuery("form.ajax").live("submit", function() {
    form = jQuery(this);
    jQuery.ajax({url: form.attr("data-event-url"), data: form.serialize()});
    return false;
  });
  jQuery("form.ajax_rel").live("submit", function() {
    form = jQuery(this);
    jQuery.ajax({url: form.attr("data-event-url"), data: form.serialize() + heartbeat_serialize(jQuery(this).attr("rel")) });
    return false;
  });

});
