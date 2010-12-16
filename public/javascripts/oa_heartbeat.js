// Heartbeat Params querying facility for the OWidget::Heartbeat widget
// It returns a string with the heartbeat params as a query string (ex: "&foo=bar ...")

var heartbeat = {};

/*
	Usage:
		heartbeat_serialize("my_note_widget1") // Get the heartbeat params for this namespace
		or
		heartbeat_serialize("my_note_widget1", {foo: "bar"}) // Get the heartbeat params for the my_note_widget1 namespace and merge with :foo => "bar"
*/

function heartbeat_serialize(namespace, hash) {
	if (typeof(heartbeat[namespace]) == 'undefined') {
		return "";
	}
  if (typeof(hash) != 'undefined') {
		// Merge the hash
    jQuery.extend(heartbeat[namespace], hash);
  }
  returned = [];
  jQuery.each(heartbeat[namespace], function(key, value) {
    if (value == null) {value = '';}
    returned.push(key + '=' + value);
  });
  return '&' + returned.join('&');
}
