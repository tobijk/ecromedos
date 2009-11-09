# -*- coding: UTF-8 -*-
# Action Script language definition file
#
# This file was taken from Andre Simon's fantastic
# syntax-highlighter "highlight" (www.andre-simon.de).

KW_LIST = {}
KW_RE = {}

KW_LIST['kwa'] = '''FCheckBox FComboBox FListBox FPushButton FRadioButton FScrollBar FScrollPane FStyleFormat getEnabled getLabel getValue registerSkinElement setChangeHandler setEnabled
setLabel setLabelPlacement setSize setStyleProperty setValue addItem addItemAt getItemAt getLength getRowCount getScrollPosition getSelectedIndex getSelectedItem removeAll
removeitemAt replaceItemAt setDataProvider setEditable setItemSymbol setRowCount setSelectionIndex sortItemsBy getSelectedIndices getSelectedItems getSelectMultiple
setAutoHideScrollBar setScrollPosition setSelectedIndex setSelectedIndices setSelectMultiple setWidth setClickHandler getGroupName setGroupName getData getState setData setState
setScrollTarget setSmallScroll setScrollProperties setHorizontal setLargeScroll getPaneHeight getPaneWidth getScrollContent loadScrollContent refreshPane setDragContent
setHScroll setScrollContent setVScroll globalStyleFormat addListener applyChanges removeListener arrow background backgroundDisabled check darkshadow embedFonts face
focusRectInner focusRectOuter foregroundDisabled highlight highlight3D radioDot ScrollTrack selection selectionDisabled selectionUnfocused shadow textAlign textBold textColor
textDisabled textFont textIndent textItalic textLeftMargin textRightMargin textSelected textSize textUnderline'''


KW_LIST['kwb'] = '''abs acos add and appendChild Array asin atan atan2 attachMovie attachSound attributes BACKSPACE Boolean break call CAPSLOCK ceil charAt charCodeAt childNodes chr
cloneNode close Color concat connect constructor continue CONTROL cos createElement createTextNode Date delete DELETEKEY do docTypeDecl DOWN duplicateMovieClip E else END ENTER
eq ESCAPE escape eval evaluate exp false firstChild floor for fromCharCode fscommand function ge getAscii getBeginIndex getBounds getBytesLoaded getBytesTotal getCaretIndex
getCode getDate getDay getEndIndex getFocus getFullYear getHours getMilliseconds getMinutes getMonth getPan getProperty getRGB getSeconds getTime getTimer getTimezoneOffset
getTransform getURL getUTCDate getUTCDay getUTCFullYear getUTCHours getUTCMilliseconds getUTCMinutes getUTCMonth getUTCSeconds getVersion getVolume getYear globalToLocal
gotoAndPlay gotoAndStop gt hasChildNodes hide hitTest HOME if ifFrameLoaded in indexOf Infinity INSERT insertBefore int isDown isFinite isNaN isToggled join Key lastChild
lastIndexOf le LEFT length LN10 LN2 load loaded loadMovie loadVariables localToGlobal log LOG10E LOG2E lt Math max MAX_VALUE maxscroll mbchr mblength mbord mbsubstring min
MIN_VALUE Mouse MovieClip NaN ne NEGATIVE_INFINITY new newline nextFrame nextScene nextSibling nodeName nodeType nodeValue not null Number Object onClipEvent onClose onConnect
OnLoad onXML or ord parentNode parseFloat parseInt parseXML PGDN PGUP PI play pop POSITIVE_INFINITY pow prevFrame previousSibling prevScene print printAsBitmap push random
removeMovieClip removeNode return reverse RIGHT round scroll Selection send sendAndLoad set setDate setFocus setFullYear setHours setMilliseconds setMinutes setMonth setPan
setProperty setRGB setSeconds setSelection setTime setTransform setUTCDate setUTCFullYear setUTCHours setUTCMilliseconds setUTCMinutes setUTCMonth setUTCSeconds setVolume
setYear shift SHIFT show sin slice sort Sound SPACE splice split sqrt SQRT1_2 SQRT2 start startDrag status stop stopAllSounds stopDrag String substr substring swapDepths TAB tan
targetPath tellTarget this toggleHighQuality toLowerCase toString toUpperCase trace true typeof unescape unloadMovie unshift UP updateAfterEvent UTC valueOf var while with void
XML xmlDecl XMLSocket apply Arguments asfunction beginFill beginGradientFill blockIndent bullet Button callee caller capabilities case check clear clearInterval contentType
createEmptyMovieClip createTextField curveTo default docTypeDecl duration ^#endinitclip embedFonts enabled endFill face font foregroundDisabled _global gloablStyleFormat
hasAccessibility hasAudio hasAudioEncoder hasMP3 hasVideoEncoder height hitArea hscroll html htmlText ignoreWhite indent ^#initclip install instanceof isActive italic language
leading leftMargin lineStyle lineTo list loadMovieNum loadScrollContent loadSound loadVariablesNum LoadVars manufacturer method moveTo multiline onChanged onData onDragOut
onDragOver onEnterFrame onKeyDown onKeyUp onKillFocus onMouseDown onMouseMove onMouseUp onPress onRelease onReleaseOutside onResize onRollout onRollOver onScroller onSetFocus
onSort onSoundComplete onUnload os password pixelAspectRatio position printAsBitmapNum printNum registerClass resolutionX resoultionY restrict scaleMode screenColor screenDPI
screenResolution size super switch System target textWidthtrackAsMenu type undefined underline uninstall unLoadMovieNum unwatch url useHandCursor variable version watch width
wordWrap'''

KW_RE['kwd'] = "regex((\\w+?)\\s*(?=\\())"

STRINGDELIMITERS = "\""

SL_COMMENT = "//"

ML_COMMENT = "/* */"

ALLOWNESTEDCOMMENTS = True

IGNORECASE = False

ESCCHAR = "\\"

SYMBOLS = "( ) [ ] { } , ; : & | < > !  = / *  %  + -"
