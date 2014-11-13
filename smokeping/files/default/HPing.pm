package Smokeping::probes::HPing;

=head1 301 Moved Permanently

This is a Smokeping probe module. Please use the command 

C<smokeping -man Smokeping::probes::Hping>

to view the documentation or the command

C<smokeping -makepod Smokeping::probes::Hping>

to generate the POD document.

=cut

use strict;
use base qw(Smokeping::probes::basefork); 
use Carp;

my $DEFAULTBIN = "/usr/sbin/hping";

sub pod_hash {
  return {
    name => <<DOC,
Smokeping::probes::Hping - a skeleton for Smokeping Probes
DOC
    description => <<DOC,
Comprobación de puertos TCP y UDP
DOC
    authors => <<'DOC',
 Celedonio Miranda cmt3@madrid.org,
DOC
    see_also => <<DOC
L<smokeping_extend>
DOC
  };
}

my $featurehash = {
        hpport => "-p",
        hpsize => "-d",
  hpflag => "-",
};
                                                                                                                              
sub features {
        my $self = shift;
        my $newval = shift;
        $featurehash = $newval if defined $newval;
        return $featurehash;
}
                                                                                                                              
sub new {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self = $class->SUPER::new(@_);
                                                                                                                              
        $self->_init if $self->can('_init');

        return $self;
}


# This is where you should declare your probe-specific variables.
# The example shows the common case of checking the availability of
# the specified binary.

sub probevars {
  my $class = shift;
        my $h = $class->SUPER::probevars;
        delete $h->{timeout};
  return $class->_makevars($h, {
    binary => { 
      _doc => "The location of your hping binary.",
      _default => $DEFAULTBIN,
      _sub => sub { 
        my $val = shift;
        -x $val or return "ERROR: binary '$val' is not executable";
                                return undef;
      },
    },
  });
}

sub targetvars {
  my $class = shift;
  return $class->_makevars($class->SUPER::targetvars, {
                timeout => {
                        _doc => 'The timeout option.',
                        _example => 1,
                        _default => 20,
                        _re => '(\d*\.)?\d+',
                },
    hpsize => { 
      _doc => "Tamaño del paquete hping.",
      _example => '-d 100',
      _default => 100 ,
      },
    hpport => { 
      _doc => "Puerto destino de la comprobación.",
      _example => '-p 23',
      _default => 23 ,
      },
    hpflag => {
      _doc => "Flags de los paquetes.",
      _example => '-S',
      _default => 'S',
      },
  });
}

sub make_host {
        my $self = shift;
        my $target = shift;
        return $target->{addr};
}
                                                                                                                              
                                                                                                                              
# other than host, count and protocol-specific args come from here
sub make_args {
        my $self = shift;
        my $target = shift;
        my @args;
        my %arghash = %{$self->features};
                                                                                                                              
        for (keys %arghash) {
                my $val = $target->{vars}{$_};
    if ( $arghash{$_} eq "-" ) {
      push @args,($arghash{$_}.$val) if defined $val; 
    }
    else {
                  push @args, ($arghash{$_}, $val) if defined $val;
    }
        }
                                                                                                                              
        return @args;
}

sub count_args {
        my $self = shift;
        my $count = shift;
                                                                                                                              
        $count = $self->pings() unless defined $count;
        return ("-c", $count);
}
                                                                                                                              

sub ProbeDesc($){
    my $self = shift;
    return "pingpong points";
}

# this is where the actual stuff happens
# you can access the probe-specific variables
# via the $self->{properties} hash and the
# target-specific variables via $target->{vars}

# If you based your class on 'Smokeping::probes::base',
# you'd have to provide a "ping" method instead
# of "pingone"

sub make_commandline {
        my $self = shift;
        my $target = shift;
        my $count = shift;
                                                                                                                              
        $count |= $self->pings($target);
                                                                                                                              
        my @args = $self->make_args($target);
        my $host = $self->make_host($target);
        push @args, $self->count_args($count);
                                                                                                                              
        return ($self->{properties}{binary}, @args, $host);
}


sub pingone ($){
        my $self = shift;
        my $t = shift;
                                                                                                                              
        my @cmd = $self->make_commandline($t);
                                                                                                                              
        my $cmd = join(" ", @cmd);
                                                                                                                              
        $self->do_debug("executing cmd $cmd");
                                                                                                                              
        my @times;
                                                                                                                              
        open(P, "$cmd 2>&1 |") or carp("fork: $!");
                                                                                                                              
        # what should we do with error messages?
        my $echoret;
        while (<P>) {
                $echoret .= $_;
    # /^len=\d+ ip=\d+\.\d+\.\d+\.\d+ ttl=\d+ DF id=\d+ sport=\d+ flags=SA seq=\d+ win=\d+ rtt=(\d+\.\d+) ms/  and push @times, $1;
    # /^len=\d+ ip=\d+\.\d+\.\d+\.\d+ ttl=\d+.*id=\d+ sport=\d+ flags=SA seq=\d+ win=\d+ rtt=(\d+\.\d+) ms/  and push @times, $1;
    # Cambiado para que accepte flags tanto SA (abiertos) como RA (cerrados)
    /^len=\d+ ip=\d+\.\d+\.\d+\.\d+ ttl=\d+.*id=\d+ sport=\d+ flags=.A seq=\d+ win=\d+ rtt=(\d+\.\d+) ms/  and push @times, $1;
        }
        close P;
        $self->do_log("WARNING: $cmd was not happy: $echoret") if $?;
        # carp("Got @times") if $self->debug;
  @times = map { sprintf "%.10e", $_/1000 } sort { $a <=> $b } grep { $_ ne "-" } @times;
                                                                                                                             
  return @times;


}

# That's all, folks!

1;
