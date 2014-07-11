use strict;
use warnings;
use Test::More;
use Test::Fake::HTTPD;

use Web::Compare;

my $left = run_http_server {
    my $req = shift;

    return [
        200,
        ['Content-Type' => 'text/html'],
        ["<html>\n<body>\nHello, Perl!\n</body>\n</html>\n"]
    ];
};

my $right = run_http_server {
    my $req = shift;

    return [
        200,
        ['Content-Type' => 'text/html'],
        ["<html>\n<body>\nHello, Ruby!\n</body>\n</html>\n"]
    ];
};

my $wc = Web::Compare->new($left->endpoint, $right->endpoint);

is $wc->report, <<_DIFF_;
@@ -1,5 +1,5 @@
 <html>
 <body>
-Hello, Perl!
+Hello, Ruby!
 </body>
 </html>
_DIFF_

done_testing;
