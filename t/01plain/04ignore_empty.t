#
#===============================================================================
#
#         FILE:  04ignore_empty.t
#
#  DESCRIPTION:  
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Pavel Boldin (), <davinchi@cpan.ru>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  15.07.2008 21:29:35 MSD
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use lib qw(t/01plain/lib);

use Test::More tests => 4;                      # last test to print

use Catalyst::Action::Wizard;
use Data::Dumper;

our $config;
our $stash;

package FakeApp;

sub new {
    bless \(my $a = ''), __PACKAGE__;
}

sub stash {
    $stash ||= {};
}

sub config {
    $config ||= {
	wizard => {
	    ignore_empty_wizard_call_pkg => [
		'TestPackage',
		'TstPckg',
		'TestPrefix::',
	    ]
	}
    }
}

my $c = FakeApp->new;

    {
	package TestPackage;
	main::isa_ok( Catalyst::Action::Wizard->wizard($c), 'Catalyst::FakeWizard', 'TestPackage fake wizard');
    }

    {
	package TstPckg;
	main::isa_ok( Catalyst::Action::Wizard->wizard($c), 'Catalyst::FakeWizard', 'TstPckg fake wizard');
    }

    {
	package TestPrefix;
	main::isa_ok( Catalyst::Action::Wizard->wizard($c, '/test'), 'Catalyst::Wizard', 'TestPrefix guine wizard');
    }

    {
	package TestPrefix::TestPackage;
	$main::stash = {};
	main::isa_ok( Catalyst::Action::Wizard->wizard($c), 'Catalyst::FakeWizard', 'TestPrefix::TestPackag fake wizard');
    }
