package Rex::Racktables::Import; 
use Rex -base;
use Rex::Ext::ParamLookup;
use Mojo::UserAgent;

# For use with the rack_api application

# Usage: rex setup server=racktables.mydomain.com
# Usage: rex update

# Changed this deployment to use agent-auth

desc 'configure racktables entry';
task 'setup', sub { 

	my $server = param_lookup "server";

	unless ($server) {
		say "No server defined. Define server=racktables.mydomain.com";
		exit 1;
	};

	my $hostname = run "hostname";
	my $hostfqdn = run "hostname -f";
	my $asset_no = run "dmidecode | grep UUID | awk {'print $2'}";
	my $comments = run "lsb_release -a";

	my $ua = Mojo::UserAgent->new;
	my $tx = $ua->post("${server}/asset" => form => { name => "$hostname" , label => "$hostfqdn" , objtype_id => 4, has_problems => "no", comment => "$comments" });

	# Return the details to the user
	if ( $tx->error) { say "FAILED" };
	if ( $tx->success) { say "Successful addition" };


};

desc 'Update the rexisting racktables details';
task 'update', sub {
	say "To be implemented";
}
