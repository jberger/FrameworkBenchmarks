#!/bin/bash

PERL_VERSION=${PERL_VERSION:-"5.18.2"};
PERL=perl-$PERL_VERSION
PERL_HOME=${IROOT}/${PERL}
INSTALLED=${IROOT}/${PERL}.installed

RETCODE=$(fw_exists $INSTALLED)
[ ! "$RETCODE" == 0 ] || { \
  source $INSTALLED
  return 0; }


fw_get -o perl-build.pl https://raw.github.com/tokuhirom/Perl-Build/master/perl-build
# compile with optimizations, n.b. this does not turn on debugging
perl perl-build.pl -DDEBUGGING=-g $PERL_VERSION $PERL 2>&1 | tee $IROOT/$PERL-install.log | perl -ne 'print "." unless $. % 100'

fw_get -o cpanminus.pl http://cpanmin.us
$PERL_HOME/bin/perl cpanminus.pl --notest --no-man-page App::cpanminus
# Install only a bare-bones of Perl modules
# Install others in the per-framework install script or cpanfile
$PERL_HOME/bin/cpanm -f --notest --no-man-page Carton JSON JSON::XS IO::Socket::IP IO::Socket::SSL

echo "export PERL_HOME=${PERL_HOME}" > $INSTALLED
echo -e "export PERL_CARTON_PATH=\$TROOT/local" >> $INSTALLED
echo -e "export PERL5LIB=\$PERL_CARTON_PATH/lib/perl5" >> $INSTALLED
echo -e "export PATH=\$PERL_CARTON_PATH/bin:\$PERL_HOME/bin:\$PATH" >> $INSTALLED

source $INSTALLED
