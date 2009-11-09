# -*- coding: UTF-8 -*-
#
# Desc:    This file is part of the eCromedos document preparation system
# Date:    2006/06/19
# Author:  Tobias Koch (tkoch@ecromedos.net)
# License: GNU General Public License, version 2
# URL:     http://www.ecromedos.net
# Update:  2006/12/30
#

book = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE book SYSTEM "http://www.ecromedos.net/dtd/2.0/ecromedos.dtd">
<book lang="en_US" fontsize="12pt" papersize="a4paper" div="12" bcor="0cm"
	secnumdepth="3" secsplitdepth="1" columns="1">

	<head>
		<subject>Subject</subject>
		<title>Title</title>
		<author>Author</author>
		<date>Date</date>
		<publisher>Publisher</publisher>
	</head>

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

	<biblio number="yes">
		<bibitem id="EXAMPLE" label="LABEL">Bibliography entry...</bibitem>
	</biblio>

</book>
"""

report = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE report SYSTEM "http://www.ecromedos.net/dtd/2.0/ecromedos.dtd">
<report lang="en_US" fontsize="12pt" papersize="a4paper" div="12" bcor="0cm"
	secnumdepth="3" secsplitdepth="1" columns="1">

	<head>
		<subject>Subject</subject>
		<title>Title</title>
		<author>Author</author>
		<date>Date</date>
		<publisher>Publisher</publisher>
	</head>

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

	<biblio number="yes">
		<bibitem id="EXAMPLE" label="LABEL">Bibliography entry...</bibitem>
	</biblio>

</report>
"""

article = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE article SYSTEM "http://www.ecromedos.net/dtd/2.0/ecromedos.dtd">
<article lang="en_US" fontsize="12pt" papersize="a4paper" div="12" bcor="0cm"
	secnumdepth="3" secsplitdepth="1" columns="1">

	<head>
		<subject>Subject</subject>
		<title>Title</title>
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
