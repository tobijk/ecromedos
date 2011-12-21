Summary: A powerful and user-friendly XML document authoring system
Name: ecromedos
Version: ###TAG###
Release: 2 
License: GPL
Group: Applications/Publishing
Source: http://ecromedos.net/files/2.0.0/ecromedos-%{version}.tar.gz
BuildRoot: /var/tmp/%{name}-buildroot
Requires: ImageMagick, texlive-latex, texlive-xetex, python >= 2.4, libxslt-python, libxml2-python

%description
ecromedos is an integrated solution for XML-based publishing in print
and on the Web. It is primarily targeted at, but not limited to, the
creation of technical documentation in the field of Computer Science.
Documents are written in a semantic markup language and converted to
representational formats with a special processing toolchain.

Currently, ecromedos supports the target formats XHTML and LaTeX, where
the latter can be compiled into high-quality PostScript or PDF by use
of the TeX  typesetting system. No previous knowledge of TeX is
required on the part of the user.

The ecromedos Markup Language (ECML) is modelled closely after HTML
with some ideas and additional elements borrowed from LaTeX. It allows
you to compose comprehensive, well-structured documents from a comparably
small set of language elements. Users who are already familiar with HTML
or document markup languages like DocBook will find learning ECML
particularly easy.

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/lib/ecromedos

for dir in $(ls); do 
  if [ -d $dir ] && [ "$dir" != "debian" ]; then
    cp -a "$dir" $RPM_BUILD_ROOT/usr/lib/ecromedos
  fi
done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc LICENSE.TXT
/usr/lib/ecromedos

%post
ln -s /usr/lib/ecromedos/bin/ecromedos /usr/bin/ecromedos

find /usr/lib/ecromedos -name "*.py" | \
while read filename; do
  if [ -f $filename ]; then
    python -c "import py_compile; py_compile.compile('$filename')"
  fi
done

%preun
find /usr/lib/ecromedos -name "*.pyc" -exec rm {} \;

%postun
rm -f /usr/bin/ecromedos

%changelog
* Wed Dec 21 2011 Tobias Koch <tobias.koch@gmail.com>
- Use vspace* to set off listing caption
- Prevent indentation of listings inside list environments
- Pass fontsize as 'fontsize=XXpt' to Koma Script
- Remove tableposition=top from default latex style
- Don't pass unicode=true to package hyperref when using xetex

* Mon Mar 15 2010 Tobias Koch <tobias.koch@gmail.com>
- Enable 'bgcolor' attribute on verbatim element
- Make background of listings transparent/white
- Handle bgcolor attribute more elegantly in XSL
- Minor improvements to the CSS style

* Wed Feb 24 2010 Tobias Koch <tobias.koch@gmail.com>
- Added 'None' as keyword to Python langdef for syntax highlighter
- Corrected spacing between title, author and date in XHTML
- Render section numbers in articles without a trailing dot
- Copy child nodes instead of text content when processing math nodes

* Sun Jan 16 2010 Tobias Koch <tobias.koch@gmail.com>
- Math is rendered properly when producing PDF via XeLaTeX
- Activate some fixes from the 'xltxtra' LaTeX package
- Made Computer Modern fonts default for all LaTeX formats

* Sun Jan 10 2010 Tobias Koch <tobias.koch@gmail.com> 
- Initial release of ecromedos version 2
