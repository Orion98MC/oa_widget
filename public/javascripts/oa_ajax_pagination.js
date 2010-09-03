jQuery(function(){
	jQuery('.pagination a').live("click", function() {
		jQuery.get(this.href, null, null, "script");
		return false;
	});
});