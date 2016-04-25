package NGWordFilter::Callbacks;

use strict;
use warnings;

sub _cb_cms_save_filter_entry {
    my ( $cb, $app ) = @_;
    my $plugin = MT->component( 'NGWordFilter' );
    my $ng_words = $plugin->get_config_value( 'filter_ng_words' );
    my @words = split( /\s*,\s*/, $ng_words );
    my $ng_words_cols = $plugin->get_config_value( 'ng_words_cols' );
    my @cols = split( /\s*,\s*/, $ng_words_cols );
    my $error;
    for my $col ( @cols ) {
        my $text = $app->param( $col );
        for my $word ( @words ) {
            $word = $plugin->translate( $word );
            if ( $text =~ m/$word/ ) {
                $error = 1;
                last;
            }
        }
        if ( $error ) {
            last;
        }
    }
    if ( $error ) {
        my $msg = $plugin->get_config_value( 'ng_words_error_msg' );
        $msg = $plugin->translate( $msg );
        return $cb->error( $msg );
    }
    1;
}

sub _cb_template_param_edit_entry {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $pointer = $tmpl->getElementById( 'title' );
    my $plugin = MT->component( 'NGWordFilter' );
    my $ng_words = $plugin->get_config_value( 'filter_ng_words' );
    return '' unless $ng_words;
    if ( $ng_words eq 'Stupid' ) {
        $ng_words = $plugin->translate( $ng_words );
    }
    $ng_words = MT::Util::encode_html( $ng_words );
    my $msg = $plugin->translate( 'NG Words are specified. \'[_1]\'', $ng_words );
    my $nodeset = $tmpl->createElement( 'app:statusMsg' );
    $nodeset->innerHTML( $msg );
    $tmpl->insertAfter( $nodeset, $pointer );
}

1;