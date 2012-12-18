var request = require('request'),
    cheerio = require('cheerio');

var arr = new Array("CIY", "NPS", "GRN", 'EYS', 'EYL', 'OSB', 'OSS', 'OSL', 'OWT', 'OTT', 'OBS', 'OPL', 'IOY');
for (var i = 0; i < arr.length; i++) {
	var url = 'http://www.techcolumbusinnovationawards.org/2011_winners_semifinalists_'+arr[i]+'.html';
	request(url, function(error, response, body) {

	  // Hand the HTML response off to Cheerio and assign that to
	  //  a local $ variable to provide familiar jQuery syntax.
	  var $ = cheerio.load(body);

	  // Exactly the same code that we used in the browser before:
	  $('div.group div.image').each(function() {
	
		  console.log("{");
		  $(this).parent().children().each(function() {
				var img = $(this).find('div.image > img').attr("src");
				var name = $(this).find('div.group > div.story > p > h6').text();
				if (name == null) { name = $(this.find('div.group > div.story > p > H6').text());}
				var url = $(this).find('div.group div.story a').attr("href");
				var story = $(this).find('div.group > div.story ~ div.story > p').text();

				if (img) {console.log('"image":'+'"'+img+'"');}
				if (name) {console.log('"name":'+'"'+name+'"');}
				if (url) {console.log('"url":'+'"'+url+'""');}
				if (story) {console.log('"story":'+'"'+story+'"');}
		
		  });

	  	console.log("},");
		});

	});
	
}

