#
#===============================================================================
#
#         FILE:  03skip.t
#
#  DESCRIPTION:  Catalyst::Wizard -skip option check
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Pavel Boldin (), <davinchi@cpan.ru>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  12.07.2008 19:47:37 MSD
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use lib qw(t/01plain/lib);

use Test::More tests => 3;
use Wizard::Test;

use Catalyst::Wizard;
use Catalyst::Action::Wizard;
use Data::Dumper;

use Digest::MD5 qw(md5_hex);

#---------------------------------------------------------------------------
#  INIT
#---------------------------------------------------------------------------

$Data::Dumper::Indent = 1;

our $wizards = {};
our $current_wizard;
our $stash = {};

my $c = TestApp->new;

my $new_wizard = Catalyst::Wizard->new( $c );

eval { $new_wizard->add_steps(-skip =>  '/testme', 'vasya', -skip => -redirect => '/pleasetestme' ) };

get_caller;

like ( $@, qr/-skip'ed steps should be/, 'error ok');


$new_wizard->add_steps(-skip => '/testme', -skip => '/vasya', '/preved');

is ( $new_wizard->_step->{path}, '/preved', 'skipping first two steps' );

$new_wizard->add_steps(-skip => '/est');

is ( $new_wizard->_step->{path}, '/preved', 'dont skip test if some before present last' );
