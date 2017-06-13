# -*- Perl -*-
#
# remote control a terminal via the TIOCSTI ioctl
#
# Run perldoc(1) on this file for additional documentation. See
# TtyWrite.xs for the code actual.

package Term::TtyWrite;

our $VERSION = '0.03';

require XSLoader;
XSLoader::load('Term::TtyWrite', $VERSION);

1;
__END__

=head1 NAME

Term::TtyWrite - remote control a terminal via the TIOCSTI ioctl

=head1 SYNOPSIS

As root.

  use Term::TtyWrite;

  my $tty = Term::TtyWrite->new("/dev/ttyp1");    # or whatever

  $tty->write("echo hi\n");
  $tty->write_delay("echo hi\n", 250);

=head1 DESCRIPTION

Remote control a terminal via the C<TIOCSTI> L<ioctl(2)>. This typically
requires that the code be run as root, or on Linux that the appropriate
capability has been granted.

This module will throw an exception if anything goes awry; use C<eval>
or L<Syntax::Keyword::Try> to catch these, if necessary.

=head1 METHODS

=over 4

=item B<new> I<device-path>

Constructor; returns an object that the B<write> method may be used on.
The B<new> method requires that a path to a device be supplied. These
will vary by operating system, and can be listed for a given terminal
with the L<tty(1)> command.

=item B<write> I<string>

Writes the given I<string> to the terminal device specified in the
constructor B<new>.

=item B<write_delay> I<string>, I<delayms>

As B<write> but with a delay of the given number of milliseconds after
each character written. The maximum delay possible is around 4294
seconds on account of the L<usleep(3)> call being limited to
C<UINT_MAX>; more control is possible by instead wrapping appropriate
sleep code around single-character calls to B<write>:

  for my $c (split //, $input_string) {
      custom_sleep();
      $tty->write($c);
  }

=back

=head1 BUGS

=head2 Reporting Bugs

Please report any bugs or feature requests to
C<bug-term-ttywrite at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Term-TtyWrite>.

Patches might best be applied towards:

L<https://github.com/thrig/Term-TtyWrite>

=head2 Known Issues

Untested portability given the use of particular ioctl()s that
L<perlport> warns about. The security concerns of running as root. Lack
of tests on account of being tricky to test what with the needing root
and injecting characters into the terminal thing.

=head1 SEE ALSO

An implementation in C:

L<https://github.com/thrig/scripts/blob/master/tty/ttywrite.c>

C<uinput> on Linux can fake keyboard input.

If possible, instead wrap the terminal with L<Expect> and control it
with that.

=head1 AUTHOR

thrig - Jeremy Mates (cpan:JMATES) C<< <jmates at cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Jeremy Mates

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a copy
of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

=cut
