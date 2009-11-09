# -*- coding: UTF-8 -*-
# CSS language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''background background-attachment background-color background-image
background-position background-repeat border border-bottom border-bottom-width
border-color border-left border-left-width border-right border-right-width
border-style border-top border-top-width border-width clear color display float
font font-family font-size font-style font-variant font-weight height
letter-spacing line-height list-style list-style-image list-style-position
list-style-type margin margin-bottom margin-left margin-right margin-top padding
padding-bottom padding-left padding-right padding-top text-align text-decoration
text-indent text-transform vertical-align white-space width word-spacing aqua auto
baseline black blink block blue bold bolder both bottom capitalize center circle
cursive dashed decimal disc dotted double fantasy fixed fuchsia gray green groove
inline inset inside italic justify large larger left lighter lime line-through
list-item lower-alpha lower-roman lowercase maroon medium middle monospace navy
no-repeat none normal nowrap oblique olive outset outside overline purple red
repeat repeat-x repeat-y rgb ridge right sans-serif scroll serif silver small
small-caps smaller solid square sub super teal text-bottom text-top thick thin top
transparent underline upper-alpha upper-roman uppercase url white x-large x-small
xx-large xx-small yellow'''

KW_LIST['kwb'] = '''a 	abbr 	acronym 	address 	applet 	area 	b 	base
basefont 	bdo 	big 	blockquote 	body 	br 	button 	caption
center 	cite 	code 	col 	colgroup 	dd 	del 	dfn
dir 	div 	dl 	dt 	em 	fieldset 	font 	form
frame 	frameset 	h1-h6 	head 	hr 	html 	i 	iframe
img 	input 	ins 	isindex 	kbd 	label 	legend 	li
link 	map 	menu 	meta 	noframes 	noscript 	object 	ol
optgroup 	option 	p 	param 	pre 	q 	s 	samp
script 	select 	small 	span 	strike 	strong 	style 	sub
sup 	table 	tbody 	td 	textarea 	tfoot 	th 	thead
title 	tr 	tt 	u 	ul 	var'''
 
KW_RE['kwc'] = "regex(\\.(\\w+)\\s*(?=\\{))"

STRINGDELIMITERS = "\""

ML_COMMENT = "/* */"

IGNORECASE = True

IDENTIFIER = "regex([a-zA-Z_][\\w\\-]*)"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
