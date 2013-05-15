#! /usr/bin/perl

use File::Find;

exit main( @ARGV );

sub main()
{
    my @argv = @_;

    print("extract all ids from svg files under directory: $argv[0]\n");
    print("Starting parse of valid ids with: $argv[1]\n");

    # open file and read it to array of lines
    &read_ids_file($argv[1]);

    find(\&create_id_list, $argv[0]);
}

sub create_id_list()
{
    my $filename = $_;

     # skip directories
    return unless -f;

    # skip non-svg files
    return unless rindex($filename, ".svg") == length($filename) - 4;

    # open file and read it to array of lines
    open( FILE, $filename ) || die( "Could not open $filename for reading: $!" );
    @lines = <FILE>;
    close(FILE) || die "Couldn't close file properly";

    # create one long string from the file
    $content = join('', @lines);

    my @ids;
    while($content =~ m/id="([^"]+)/g)
    {
        if (grep {$_ =~ "^$1\$"} @valid_ids)
        {
            push(@ids, $1);
        }
    }

    if(@ids)
    {
        my $outputfilename = $filename.".ids";
        open( OUTPUT, ">$outputfilename") || die( "Could not open $outputfilename for writing: $!" );
        foreach(@ids)
        {
            print OUTPUT "$_\n";
        }
        close(OUTPUT) || die "Couldn't close file properly";
    } else
    {
        print "No valid ids found in $filename\n";
    }

    return 0;
}

sub read_ids_file()
{
    my ($idstxt) = @_;

    # open file and read it to array of lines
    open( FILE, $idstxt ) || die( "Could not open $idstxt for reading valid ids: $!" );
    @tmp_ids = <FILE>;
    close(FILE) || die "Couldn't close file properly";

    foreach(@tmp_ids)
    {
        if ($_ =~ m/^@([\w\/]*\.txt)/)
        {
            push(@other_ids_files, $1);
        }

        if ($_ =~ m/^([\w-]*)/)
        {
            push(@valid_ids, $1);
        }
    }

    foreach(@other_ids_files)
    {
        print("Also parsing $_ for valid ids.\n");
        open( FILE, $_ ) || die("Could not open $_ for reading valid ids: $!");
        @tmp_ids = <FILE>;
        close(FILE) || die "Couldn't close file properly";

        foreach(@tmp_ids)
        {
            if ($_ =~ m/^([\w-]*)/)
            {
                push(@valid_ids, $1);
            }
        }
    }
}
