use LWP::UserAgent;
system('cls');
print qq(
################################
#   Checker Emails Twitter     #
################################
#     Coded By 1337r00t        #
################################
#                              #
#   Instagram : 1337r00t       #
#                              #
#    Twitter : _1337r00t       #
#                              #
################################
Enter [CTRL+C] For Exit :0\n);
print qq(
Enter Emails File :
> );
$emails=<STDIN>;
chomp($emails);
open (EMAILFILE, "<$emails") || die "[-] Can't Found ($emails) !";
@EMAILS = <EMAILFILE>;
close EMAILFILE;
foreach $email (@EMAILS) {
chomp $email;
	$checker = LWP::UserAgent->new();
	$checked = $checker->get("https://twitter.com/users/email_available?email=$email");
	if($checked->content =~ /"msg":"Available!"/){
		print "($email)-> Available\n";
	}
	else
	{
		print "($email)-> NotAvailable\n";
	}
}
