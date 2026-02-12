#!/bin/sh

do_clean() {
    rm -fr html pdf spool
}    
 
do_build() {
    mkdir -p html pdf spool

    (cd html  && ../../bin/ecromedos -f xhtml   ../src/manual.xml)
    (cd spool && ../../bin/ecromedos -f xelatex ../src/manual.xml)

    (
        cd spool
        for i in `seq 1 3`
        do
            xelatex -interaction=nonstopmode main.tex
        done
    )

    cp spool/main.pdf  pdf/user-manual.pdf
    cp spool/main.pdf html/user-manual.pdf
}

case "$1" in
    clean)
        do_clean
        ;;
    *)
        do_clean
        do_build
        ;;
esac

