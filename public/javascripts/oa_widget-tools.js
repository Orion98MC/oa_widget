/*
	patch the links to use ajax calls
	links must have a "action_link_with_id" or "action_link" css class name set
	if the link also has the "confirm_*action*" css class set, a confirmation is prompted for *action* (ex: confirm_delete)
	Usage:
		patch_link_to_ajax_for_namespace('my_note_widget1', 'note')
*/

function patch_link_to_ajax_for_namespace(namespace, entity_name) {
	jQuery(function(){
		// patch links to ajax call with entity_id attribute
		jQuery('div#' + namespace + ' a.action_link_with_id').live("click", function() {
			if ((match = jQuery(this).attr('class').match(/confirm_(.*)/)) && !confirm(match[1].charAt(0).toUpperCase() + match[1].slice(1) + " this " + entity_name + "?")) {
			  return false;
			}
			jQuery.get(this.href + savedParams(namespace, {'id': jQuery(this).attr(entity_name + '_id')}), null, null, "script");
			return false;
		});

		// patch links to ajax call
	  jQuery('div#' + namespace + ' a.action_link').live("click", function() {
	    jQuery.get(this.href + savedParams(namespace), null, null, "script");
			return false;
		});
	});
}

/*
	nubin show/hide facility
	applies to any div with a "has_child_nubins" css class set on it
	the div MUST have a child with a hidden "nubins" css class set on it
	The "nubins" class elements must have a 'display: none;' style set to work correctly
*/

jQuery(function(){	
	jQuery('.has_child_nubins').live("mouseover", function(){
		var nubin = jQuery(this).children(".nubins.auto_hide.hidden");
		nubin.removeClass('hidden');
	});

	jQuery('.has_child_nubins').live("mouseout", function(){
		var nubin = jQuery(this).children(".nubins.auto_hide");
		nubin.addClass('hidden');
	});
});
