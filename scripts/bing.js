var btoa = require('btoa');

var key = process.env.HUBOT_BING_KEY || '';
var auth = new Buffer([ key, key ].join(':')).toString('base64');
var rootURL = 'https://' + key + ':' + key + '@api.datamarket.azure.com/Bing/Search/';
var searchType = 'Image';
var market = '%27en-us%27';
var safe_search = '%27Off%27';




module.exports = function(robot) {
	robot.respond(/(bing)( me)? (.*)/i, function(msg) {

		if( key == '' ){ return msg.send('Set your Bing Key moron.') }

		var query = encodeURIComponent( "'" + msg.match[3] + "'" );

		var full_url = rootURL + searchType + '?$format=json&Query=' + query + '&Market=' + market + '&Adult=' + safe_search;

		// msg.send(full_url);

		msg.http(full_url).get()( function(err, res, body) {
			if( err ){
				return msg.send( 'Error: ' + err );
			} else {
				if( res.statusCode != 200 ){
					return msg.send( 'did not get 200 back: ' + res.statusCode );
				} else {
					if( !body || body == '' ){
						return msg.send('wtf no stoofs?')
					} else {
						body = JSON.parse(body);
						var first = body.d;
						if( !first || first == '' ){
							return msg.send('cant find the d');
						} else {
							var results = first.results;
							if( !results || results == '' ){
								return msg.send('cant find results');
							} else {
								var randy = Math.floor(Math.random() * results.length);
								var post = results[randy];



								return msg.send(post.MediaUrl);
							}
						}
					}

				}
			}

		});
	});
}
