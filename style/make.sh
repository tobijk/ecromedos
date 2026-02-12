#!/bin/sh

##############################################################################
# Functions
##############################################################################

do_clean()
{
    rm -fr css
    rm -f style.css
}

do_build()
{
    do_clean
    mkdir -p css

    ls scss/ | while read scss_file
    do
        # continue if not a regular file
        test -f scss/$scss_file || continue

        python3 -c "
import sass, sys
print(sass.compile(filename=sys.argv[1], output_style='expanded', precision=8))
" scss/$scss_file >> css/`basename $scss_file .scss`.css
    done

    rm -f css/variables.css
    rm -f style.css

    for css_file in normalize grid layout style
    do
        cat "css/${css_file}.css" >> style.css
    done

    # install into XSLT directory
    STYLE_XML="../xslt/html/style.xml"

    cat > "$STYLE_XML" <<'HEADER'
<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Desc:    This file is part of the ecromedos Document Preparation System
 - Author:  Tobias Koch <tobias@tobijk.de>
 - License: MIT
 - URL:     http://www.ecromedos.net
-->
<style>
    <css><![CDATA[
HEADER

    cat style.css >> "$STYLE_XML"

    cat >> "$STYLE_XML" <<'FOOTER'
    ]]></css>
</style>
FOOTER
}

##############################################################################
# Main
##############################################################################

case "$1" in
    clean)
        do_clean
        ;;
    *)
        do_clean
        do_build
        ;;
esac

