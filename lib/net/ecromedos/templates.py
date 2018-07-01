# -*- coding: utf-8 -*-
#
# Desc:    This file is part of the ecromedos Document Preparation System
# Author:  Tobias Koch <tobias@tobijk.de>
# License: MIT
# URL:     http://www.ecromedos.net
#

book = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "http://www.ecromedos.net/dtd/3.0/ecromedos.dtd">
<book lang="en_US" fontsize="12pt" papersize="a4paper" div="14" bcor="0cm"
    secnumdepth="3" secsplitdepth="1">

    <head>
        <subject>Subject</subject>
        <title>Title</title>
        <subtitle>Subtitle</subtitle>
        <author>Author</author>
        <date>Date</date>
        <publisher>Publisher</publisher>
    </head>

    <legal>
        <p>
        Legal info.
        </p>
    </legal>

    <make-toc depth="3" lof="no" lot="no" lol="no"/>

    <preface>
        <title>Preface</title>
        <p>
            First paragraph in first preface...
        </p>
    </preface>

    <!-- you may want to group your chapters into parts like this:
    <part>
        <title>Part Title</title>
    -->

    <chapter>
        <title>Chapter Title</title>
        <p>
            First paragraph in first chapter...
        </p>
    </chapter>

    <!-- end part:
    </part>
    -->
    
    <appendix>
        <title>First Appendix</title>
        <p>
            First paragraph in first appendix...
        </p>
    </appendix>

    <make-glossary locale="en_US" alphabet="[Symbols],A,B,C,D,E,F,G,H,I,J,
      K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" tocentry="yes"/>

    <biblio number="yes">
        <bibitem id="EXAMPLE" label="LABEL">Bibliography entry...</bibitem>
    </biblio>

    <make-index group="default" locale="en_US" alphabet="[Symbols],A,B,C,
        D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" tocentry="yes"
        columns="2"/>

</book>
"""

report = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "http://www.ecromedos.net/dtd/3.0/ecromedos.dtd">
<report lang="en_US" fontsize="12pt" papersize="a4paper" div="14" bcor="0cm"
    secnumdepth="3" secsplitdepth="1">

    <head>
        <subject>Subject</subject>
        <title>Title</title>
        <subtitle>Subtitle</subtitle>
        <author>Author</author>
        <date>Date</date>
        <publisher>Publisher</publisher>
    </head>

    <legal>
        <p>
        Legal info.
        </p>
    </legal>

    <make-toc depth="3" lof="no" lot="no" lol="no"/>

    <preface>
        <title>Preface</title>
        <p>
            First paragraph in first preface...
        </p>
    </preface>

    <chapter>
        <title>Chapter Title</title>
        <p>
            First paragraph in first chapter...
        </p>
    </chapter>
    
    <appendix>
        <title>First Appendix</title>
        <p>
            First paragraph in first appendix...
        </p>
    </appendix>

    <make-glossary locale="en_US" alphabet="[Symbols],A,B,C,D,E,F,G,H,I,J,
      K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" tocentry="yes"/>

    <biblio number="yes">
        <bibitem id="EXAMPLE" label="LABEL">Bibliography entry...</bibitem>
    </biblio>

    <make-index group="default" locale="en_US" alphabet="[Symbols],A,B,C,
        D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" tocentry="yes"
        columns="2"/>

</report>
"""

article = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE article SYSTEM "http://www.ecromedos.net/dtd/3.0/ecromedos.dtd">
<article lang="en_US" fontsize="12pt" papersize="a4paper" div="14" bcor="0cm"
    secnumdepth="3" secsplitdepth="0">

    <head>
        <subject>Subject</subject>
        <title>Title</title>
        <subtitle>Subtitle</subtitle>
        <author>Author</author>
        <date>Date</date>
        <publisher>Publisher</publisher>
    </head>

    <make-toc depth="3" lof="no" lot="no" lol="no"/>

    <abstract>
        <p>
            Document summary...
        </p>
    </abstract>
    
    <section>
        <title>Section Title</title>
        <p>
            First paragraph in first section...
        </p>
    </section>

    <biblio number="yes">
        <bibitem id="EXAMPLE" label="LABEL">Bibliography entry...</bibitem>
    </biblio>

</article>
"""

