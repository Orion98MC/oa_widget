// Saved Params querying facility for the OWidget::Heartbeat widget
// It returns a string with the saved params as a query string (ex: "&foo=bar ...")

var saved_params = {};

/*
	Usage:
		savedParams("my_note_widget1") // Get the saved params for this namespace
		or
		savedParams("my_note_widget1", {foo: "bar"}) // Get the saved params for the my_note_widget1 namespace and merge with :foo => "bar"
*/

function savedParams(namespace, hash) {
  if (typeof(hash) != 'undefined') {
    jQuery.extend(saved_params[namespace], hash);
  }
  returned = [];
  jQuery.each(saved_params[namespace], function(key, value) {
    if (value == null) {value = '';}
    returned.push(key + '=' + value);
  });
  return '&' + returned.join('&');
}
