// Description:
// 	None
//
// Dependencies:
// 	None
//
// Configuration:
// 	None
//
// Commands:
// 	hubot ichooseyou <pokemon> - Call upon your <pokemon>
//
// Author:
// 	v3xx3d


var api_root = "http://pokeapi.co/";
var api_pokedex = "api/v1/pokedex/1/";
var api_media = "media/img/";
var full_pokedex;



function run( pokemon, msg ){
	pokemon = pokemon.toLowerCase();
	if( !full_pokedex ){
		msg.http( api_root+api_pokedex ).get()(function( err, res, body ){
			if( err ){
				return msg.send( 'Error: ' + err );
			} else {
				if( !body || body == '' ){
					return msg.send('wtf no stoofs?')
				} else {
					var response = JSON.parse( body );
					full_pokedex = response.pokemon;
					searchPokedex( pokemon, msg );
				}
			}
		});
	} else {
		searchPokedex( pokemon, msg );
	}
}


function getPokemonInfo( resource_uri, msg ){
	msg.http( api_root+resource_uri ).get()(function( err, res, body ){
		if( err ){
			return msg.send( 'Error: ' + err );
		} else {
			if( !body || body == '' ){
				return msg.send('wtf no stoofs?')
			} else {
				var response = JSON.parse( body );
				var poke_id = response.national_id;
				return msg.send( api_root + api_media + poke_id + ".png" );
			}
		}
	});
}


function searchPokedex( pokemon, msg ){
	for( var i = 0; i < full_pokedex.length; i++ ){
		if( full_pokedex[i].name == pokemon ){
			return getPokemonInfo( full_pokedex[i].resource_uri, msg );
		}
	}
	return msg.send( 'Pokemon not found!' );
} 


module.exports = function(robot){
	robot.hear(/ichooseyou( .+)*/i, function(msg){
		run( msg.match[1].trim(), msg );
	});
}


