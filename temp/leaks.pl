use 5.010;
use strict;
use Test::More;
use Test::Deep;
use FindBin;
use lib "t/lib","lib","$FindBin::Bin/../blib/lib","$FindBin::Bin/../blib/arch";
use EV;
use EV::Tarantool16;
use Time::HiRes 'sleep','time';
use Data::Dumper;
use Errno;
use Scalar::Util 'weaken';
use Renewer;
use Devel::Leak;
use Devel::Peek;
use AE;

my $var;
# Devel::Leak::NoteSV($var);

my $cfs = 0;
my $connected;
my $disconnected;

my $tnt = {
	port => 3301,
	host => '127.0.0.1',
	username => 'test_user',
	password => 'test_pass',
};

my $cnt = 0;
my $max_cnt = 30000;


Devel::Leak::NoteSV($var);

my $c; $c = EV::Tarantool16->new({
	host => $tnt->{host},
	port => $tnt->{port},
	username => $tnt->{username},
	password => $tnt->{password},
	reconnect => 0.2,
	log_level => 1,
	connected => sub {
		# diag Dumper \@_ unless $_[0];
		$c->disconnect;
		return EV::unloop if ++$cnt >= $max_cnt;
		$c->connect;
	},
	connfail => sub {
		my $c = shift;
		warn "@_ / $!";
		EV::unloop;
	},
	disconnected => sub {
		# warn "discon: @_ / $!";
		# EV::unloop;
	},
});

$c->connect;
EV::loop;
undef $c;

Devel::Leak::CheckSV($var);


# $c->insert('memier', [7, {a => 1, b => 2}], { in => 's*' }, sub {
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;


# $c->call('get_test_tuple', [], {space => 'tester'}, sub {
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;

# $c->update('test', [
# 	'a',
# 	'b'
# ], [
# 	[4 => '=', 'T']
# ], {index => 'ident'}, sub {
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;

# $c->ping("", sub {
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;

# my $p = [{_t1 => 't1',_t2 => 't2',_t3 => 17}, [ [4 => ':', 0, 3, 'romy'] ],  { hash => 1 }];

# for (1..100000) {
# $c->update('tester', $p->[0], $p->[1], $p->[2], sub {
# 	my $a = @_[0];
# 	EV::unloop;
# });
# EV::loop;
# }
# undef $p;
# undef $c;

# Devel::Leak::CheckSV($var);

# $c->call("string_function1", [], {timeout => 10}, sub {
#     say Dumper \@_;
#     EV::unloop;
# });
# EV::loop;

# $c->select('_space', [], {hash => 0}, sub {
# 	my ($a) = @_;
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;


# my $finished = 0;
# $c->eval("return {box.info}", {}, sub {
#     my $a = @_[0];
#     say 'hello';
#     say Dumper \@_;
#     $finished = 1;
#     EV::unloop;
# });
# if (!$finished) {
# 	EV::loop;
# }
# undef $c;


# }


# for (1..10) {

# $c->ping(sub {
# 	# say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;

# $c->select('tester', {_t1=>'t1', _t2=>'t2'}, {hash => 1, iterator => 'LE'}, sub {
# 	my ($a) = @_;
# # 	# my $size = @{$a->{tuples}->[0]};
# # 	# say $size;
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;

# $c->call("status_wait1", [], {timeout => 10}, sub {
#     say Dumper \@_;
#     EV::unloop;
# });
# EV::loop;

# $c->eval("return {box.space.tester:len{}}", [], sub {
#     say 'here';
#     my $a = @_[0];
#     say Dumper \@_;
#     EV::unloop;
# });
# EV::loop;

# $c->select('tester', {_t1=>'t1', _t2=>'t2'}, {hash => 1, iterator => 'LE'}, sub {
# 	my ($a) = @_;
# # 	# my $size = @{$a->{tuples}->[0]};
# # 	# say $size;
# 	# say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;

# }

# undef $c;

# Devel::Leak::CheckSV($var);


# $c->select('tester', [], {hash=>0}, sub {
# 	my ($a) = @_;
# 	# my $size = @{$a->{tuples}->[0]};
# 	# say $size;
# 	say Dumper \@_;
# 	EV::unloop;
# });
# EV::loop;


# undef $c;
# undef $tnt;
# }


# for (1..10) {
# $c->ping(sub {
# 	my $a = @_[0];
# 	say Dumper \@_ if !$a;
# 	# is $a->{code}, 0;
# 	EV::unloop;
# });
# EV::loop;
# }

# my $p = [["t1", "t2", 101, '-100', { a => 11, b => 12, c => 13 }], { replace => 0, hash => 0 }];

# for (1..10) {
# $c->insert('tester', $p->[0], $p->[1], sub {
# 	my $a = @_[0];

# 	EV::unloop;
# });
# EV::loop;
# }
# undef $p;

# my $p = [{_t1=>'t1', _t2=>'t2'}, {hash => 1, iterator => 'LE'}];
# for (1..10) {
# $c->select('tester', $p->[0], $p->[1], sub {
# 			my $a = @_[0];
# 			EV::unloop;
# 		});
# EV::loop;
# }
# undef $p;

# my $p = [['tt1', 'tt2', 456], {}];

# for (1..10) {
# $c->delete('tester', $p->[0], $p->[1], sub {
# 	my $a = @_[0];
# 	EV::unloop;
# });
# EV::loop;
# }
# undef $p;

# my $p = [{_t1 => 't1',_t2 => 't2',_t3 => 17}, [ [4 => ':', 0, 3, 'romy'] ],  { hash => 1 }];

# for (1..10) {
# $c->update('tester', $p->[0], $p->[1], $p->[2], sub {
# 	my $a = @_[0];
# 	EV::unloop;
# });
# EV::loop;
# }
# undef $p;



# Devel::Leak::CheckSV($var);
