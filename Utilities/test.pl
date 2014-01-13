sub quote {
  ($str) = @_;
  return "\"$str\"";
}

@vals = split(/,/, $_);
$company = quote($vals[1]);
$fb = quote($vals[2]);
$tw = quote($vals[3]);
$li = quote($vals[5]);

print <<HERE;
"$vals[1]":{
  "company":"$vals[1]",
  "company_facebook":"$vals[2]",
  "company_twitter":"$vals[3]",
  "personal_linkedin":"$vals[5]"
},
HERE
