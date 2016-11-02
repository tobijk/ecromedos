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

        sass -C --scss --style expanded scss/$scss_file \
            --precision 8 \
            >> css/`basename $scss_file .scss`.css
    done

    rm -f css/variables.css
    rm -f style.css

    for css_file in normalize grid layout style
    do
        cat "css/${css_file}.css" >> style.css
    done
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

