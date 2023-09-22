use v6;

grammar HTML_table
{
    token TOP {
        <.rubbish>+?
        <.ws> '<thead>'
        <header>
        <.ws> '</thead>'
        <.ws> '<tbody>'
        <row>+
        <.ws> '</tbody>'
        <.rubbish>+
    }
    rule header {
        <?> '<tr>' ~ '</tr>' <field>*
    }
    regex field {
        <.ws> '<th>' ~ '</th>' (.*?)
    }
    rule row {
        <?> '<tr>' ~ '</tr>' <data>*
    }
    regex data {
        <.ws> '<td>' ~ '</td>' (.*?)
    }
    regex rubbish {
        \N* \n
    }
}

class HTML_table_actions
{
    method header($/) {
        make $<field>>>.made;
    }
    method field($/) {
        # make ~$/[0];  # verbatim
        make $/[0].defined ?? $/[0].Str.trim !! '';
    }
    method row($/) {
        make $<data>>>.made;
    }
    method data($/) {
        # make ~$/[0];  # verbatim
        make $/[0].defined ?? $/[0].Str.trim !! '';
    }
}

my $parser;
my @file_list = dir(test => / :i '.' html $ /);
my $file_name = @file_list[0].substr: 0, 16;
my $output_file = open $file_name ~ ".csv", :w;
my $file_content;
for @file_list {
    $file_content = slurp($_, enc => 'iso-8859-1');
    say "Parsing: $_";
    $parser = HTML_table.parse($file_content, actions => HTML_table_actions.new);
    unless $parser {
        say "Unable to parse: $_";
        last;
    };
    once { $output_file.print("{ $parser<header>.made.join: ';'; }\n") };
    $output_file.print("{ .join: ';'; }\n") for $parser<row>>>.made;
}
$output_file.close;
