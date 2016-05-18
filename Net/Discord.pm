package Net::Discord;

use v5.10;
use warnings;
use strict;

use Net::Discord::Gateway;
use Net::Discord::REST;

sub new
{
    my ($class, $params) = @_;
    my $self = {};

    die("Net::Discord::REST requires a Token.") unless defined $params->{'token'};
    die("Net::Discord::REST requires an application name.") unless defined $params->{'name'};
    die("Net::Discord::REST requires an application URL.") unless defined $params->{'url'};
    die("Net::Discord::REST requires an application version.") unless defined $params->{'version'};

    # Store the token, application name, url, and version
    $self->{'token'}        = $params->{'token'};
    $self->{'name'}         = $params->{'name'};
    $self->{'url'}          = $params->{'url'};
    $self->{'version'}      = $params->{'version'};

    # Store the callbacks if they exist
    $self->{'callbacks'}    = $params->{'callbacks'} if exists $params->{'callbacks'};

    # API Vars - Will need to be updated if the API changes
    $self->{'base_url'}     = 'https://discordapp.com/api';

    # Create the Gateway and REST objects
    my $gw                  = Net::Discord::Gateway->new($self);
    my $rest                = Net::Discord::REST->new($self);

    $self->{'gw'}           = $gw;
    $self->{'rest'}         = $rest;

    bless $self, $class;
    return $self;
}

sub connect
{
    my $self = shift;

    # Get Gateway URL
    my $gw_url = $self->{'gw'}->gateway;

    $self->{'gw'}->connect($gw_url);
}

sub send_message
{
    my ($self, $channel, $reply) = @_;

    $self->{'rest'}->send_message($channel, $reply);
}

sub start_typing
{
    my ($self, $channel) = @_;

    $self->{'rest'}->start_typing($channel);
}

sub status_update
{
    my ($self, $params) = @_;
    
    $self->{'gw'}->status_update($params);
}

1;
