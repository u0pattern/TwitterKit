#!usr/bin/perl
use LWP::UserAgent;
sub ct0(){
	$sess = LWP::UserAgent->new();
	$sessed = $sess->get('https://twitter.com/');
	if($myct = $sessed->header('set-cookie')=~/ct0=(.+?);/){
		$c = $1;
	}
	return $c;
}
sub key(){
	$k = LWP::UserAgent->new();
	$k->default_header("Authorization" => 'Bearer AAAAAAAAAAAAAAAAAAAAAFXzAwAAAAAAMHCxpeSDG1gLNLghVe8d74hl6k4%3DRUMF4xAQLsbeBhTSRrCiQpJtxoGWeyHrDb5te2jpGskWDFW82F');
	$r = $k->post('https://api.twitter.com/1.1/guest/activate.json',{});
	return $r->content=~/{"guest_token":"(.+?)"}/;
}
sub flow_token(){
	$f = LWP::UserAgent->new();
	$f->default_header("content-type"=>'application/json');
	$f->default_header("authorization"=>'Bearer AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA');
	$f->default_header("x-guest-token"=>'1022921332416307200');
	$fr = $f->post('https://api.twitter.com/1.1/onboarding/task.json?flow_name=signup', Content => '{"input_flow_data":{}}');
	if($fr->content=~/{"flow_token":"(.+?)"/){ $flow = $1; }
	return $flow;
}
sub create(){
	$cr = LWP::UserAgent->new();
	$cr->default_header("content-type"=>'application/json');
	$cr->default_header("authorization"=>'Bearer AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA');
	$cr->default_header("x-guest-token"=>'1022921332416307200');
	$po = '{"flow_token":"'.flow_token().'","subtask_inputs":[{"subtask_id":"GenerateTemporaryPassword","fetch_temporary_password":{"password":"8a36acd2e8c130731744","link":"next_link"}},{"subtask_id":"Signup","sign_up":{"email":"jfuguhru'.time().'gh@gmail.com","js_instrumentation":{"response":"{}"},"link":"next_link","name":"1337r00td","personalization_settings":{"allow_cookie_use":true,"allow_device_personalization":true,"allow_partnerships":true,"allow_ads_personalization":true}}},{"subtask_id":"SignupReview","sign_up_review":{"link":"signup_with_email_next_link"}}]}';
	$cre = $cr->post('https://api.twitter.com/1.1/onboarding/task.json', Content => $po);
	if($cre->header('set-cookie')=~/auth_token=(.+?);/){ $token=$1; }
	return $token;
}
sub bot($auth){
	$bt = LWP::UserAgent->new();
	$bt->default_header("authorization"=>'Bearer AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA');
	$bt->default_header("x-csrf-token"=>ct0());
	$bt->default_header("x-guest-token"=>'1022921332416307200');
	$bt->default_header("Cookie"=>'ct0='.ct0().'; auth_token='.$auth.';');
	$bte = $bt->get('https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=1');
	if($bte->content=~/"screen_name":"(.+?)"/){ $user = $1; }
	return $user;
}
$a = create();
print bot($a);
