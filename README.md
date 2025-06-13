# jddownloads_file_types (1.0)
Checks the file type icon for listings in the jddownloads file manager component

***

1. Copy **config.ini.example** to **config.ini** and edit it for your settings. If you don't know what your table prefix is you can use the following commands to see what it is. The prefix MUST end with a "_".

        mysql -p
        use joomla;
        show tables;
        quit;

        The prefix is what appears at the start of every field in that list.

2. Use CPAN to install the following Perl modules:

        IO::Socket::PortState
        DBI
        Email::Simple
        Email::Simple::Creator
        Email::Sender::Simple qw(sendmail)


3. That should be enough, it should be workable now.
