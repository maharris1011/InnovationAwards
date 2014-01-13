var request = require('request'),
    cheerio = require('cheerio');

var arr = new Array(
  {name:"Innovation in Non-Profit Service Delivery",abbrev:"NPS"},
  {name:"Green Innovation", abbrev:"GRN"},
  {name:"Executive of the Year (-250)", abbrev:"EYS"},
  {name:"Executive of the Year (+250)", abbrev:"EYL"},
  {name:"Outstanding Startup Business", abbrev:"OSB"},
  {name:"Outstanding Service (-250)", abbrev:"OSS"},
  {name:"Outstanding Service (+250)", abbrev:"OSL"},
  {name:"Outstanding Technology Team", abbrev:"OTT"},
  {name:"Outstanding Woman in Technology", abbrev:"OWT"},
  {name:"Outstanding Product (-250)", abbrev:"OPS"},
  {name:"Outstanding Product (+250)", abbrev:"OPL"},
  {name:"Inventor of the Year", abbrev:"IOY"}
  );
var waiting = arr.length;

get_categories(arr);

function print_category(cat)
{
  if (--waiting == 0)
  {
    console.log(JSON.stringify(arr));
  }
}

function parse_semifinalist(node)
{
  var sf = {};

  sf.img = node.find('img#sf_photo').attr("src") || "";
  var company_node = node.find('h9#sf_company');
  sf.company =company_node.text() || "";
  sf.contact = node.find('h10#sf_contact').text() || "";
  sf.site_url = node.find('a#sf_website').attr("href") || "";
  sf.bio = node.find('#sf_bio').text() || "";
  sf.linkedIn = node.find('#sf_linkedin').attr("href") || "";
  sf.twitter = node.find('#sf_twitter').attr("href") || "";
  sf.facebook = node.find('#sf_facebook').attr("href") || "";
  if (node.children().first().hasClass('post-author-winner-info')) {
    sf.winner = "true";
  }
  return sf;
}

function parse_category(cat) 
{
  request(cat.url, function(error, response, body) {

    // Hand the HTML response off to Cheerio and assign that to
    //  a local $ variable to provide familiar jQuery syntax.
    var $ = cheerio.load(body);

    cat.semifinalists = [];
    
    // push each semifinalist into the array
    $('div.post-author-info').each(function() {
        cat.semifinalists.push(parse_semifinalist($(this)));
    });

    // signal we're done
    print_category(cat);
  });
}


function get_categories(categories)
{
  for (var i = 0; i < categories.length; i++) 
  {
      var cat = arr[i];
      cat.url = 'http://www.techcolumbusinnovationawards.org/2012_WSF_'+cat.abbrev+'.html';

      parse_category(cat);
  }
}



