#!/usr/bin/env perl -wT
use strict;
use CGI;

$CGI::DISABLE_UPLOADS = 1;      # Disable uploads
$CGI::POST_MAX        = 51_200; # Maximum number of bytes per post

my $query = CGI->new();
