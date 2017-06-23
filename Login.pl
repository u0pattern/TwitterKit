use LWP::UserAgent;
system('cls');
system('color 1e');
print '
###################
# Coded By 1337r00t
###################
...........................................................................
.%%%%....%%%%%%..%%%%%%..%%%%%%.......%%%%%%\...../%%%\..../%%%\....%%%%%%.
...%%........%%......%%.....(%/.......%%....%)...%:...:%..%:...:%.....%%...
...%%....%%%%%%..%%%%%%....(%/........%%%%)%.}...%:...:%..%:...:%.....%%...
...%%........%%......%%...(%/.........%%...\%)...%:...:%..%:...:%.....%%...
.%%%%%%..%%%%%%..%%%%%%..(%...........%%....\%)...\%%%/....\%%%/......%%...
...........................................................................
';
######################
print qq(
Enter Username
> );
$username=<STDIN>;
chomp($username);
######################
print qq(
Enter Password
> );
$password=<STDIN>;
chomp($password);
######################
$ua = LWP::UserAgent->new;
$stream = '@stream.twitter.com/1.1/statuses/filter.json';
$request = HTTP::Request->new(GET => "https://$username:$password$stream");
$response = $ua->request($request);
if ($response->content=~ /Basic auth no longer supported./) {
	print "Logged ($username:$password)";
}
else {
	print "Failed ($username:$password)";
}
