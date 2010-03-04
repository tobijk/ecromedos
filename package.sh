#!/bin/bash

###############################################################################

ERR_USAGE=1
ERR_NOTAG=2
ERR_NODIR=3
ERR_TAGNO=4

###############################################################################

function usage #()
{
	echo "Usage: package.sh <tag> <outdir>"
}

function error #(code, msg)
{
	local code=$1
	local msg=$2
	echo "$msg" >&2
	exit $code
}

function check_tag #(tag)
{
	local tag=$1
	local current_branch=`git branch | egrep "^\*" | cut -d' ' -f2`

	# check for tag
	git checkout $tag > /dev/null 2>&1 || {
		error $ERR_NOTAG "Could not check out tag '$tag'."
	}

	if [ -n "$current_branch" ]; then
		git checkout $current_branch > /dev/null 2>&1
	else
		git checkout $master > /dev/null 2>&1
	fi
}

function check_outdir #(outdir)
{
	local outdir=$1

	# check for existence
	test -d "$outdir" || {
		echo "No such directory '$outdir'."
		exit $ERR_NODIR
	}
}

function build_rpm #(tag, outdir)
{
	local tag=$1
	local outdir=$2
	local tmpdir="`mktemp -d`"

	echo -n "Building RPM package in $tmpdir..."

	# create rpm build subdirs
	mkdir -p $tmpdir/{RPMS,BUILD,SOURCES,SPECS,SRPMS}

	# build tarball
	git archive --prefix=ecromedos-${tag}/ --format=tar ${tag} | \
		(cd ${tmpdir}/SOURCES && \
		tar -x \
			--exclude=.gitignore \
			--exclude=debian \
			--exclude=ecromedos.spec \
			--exclude=package.sh -f - && \
		tar -czf ecromedos-${tag}.tar.gz ecromedos-${tag} && \
		rm -fr ecromedos-${tag})

	# update tag in spec file
	cat ecromedos.spec | sed "s/###TAG###/$tag/" > \
		$tmpdir/SPECS/ecromedos-${tag}.spec

	# build package
	if [ $DEBUG ]; then
		rpmbuild --nodeps --target="noarch" --define="%_topdir $tmpdir" \
			-ba $tmpdir/SPECS/ecromedos-${tag}.spec
	else
		rpmbuild --nodeps --target="noarch" --define="%_topdir $tmpdir" \
			-ba $tmpdir/SPECS/ecromedos-${tag}.spec	> /dev/null
	fi

	# fetch build artifacts
	mv $tmpdir/RPMS/*/*.rpm $outdir/rpm
	mv $tmpdir/SRPMS/*.rpm $outdir/rpm

	# cleanup
	rm -fr $tmpdir

	echo "done"
}

function build_tgz #(tag, outdir)
{
	local tag=$1
	local outdir=$2
	local tmpdir="`mktemp -d`"

	echo -n "Building TGZ package in $tmpdir..."

	# build tarball
	git archive --prefix=ecromedos-${tag}/ --format=tar ${tag} | \
		(cd ${tmpdir} && \
		tar -x \
			--exclude=.gitignore \
			--exclude=debian \
			--exclude=ecromedos.spec \
			--exclude=package.sh -f - && \
		fakeroot tar -czf ecromedos-${tag}.tar.gz ecromedos-${tag} && \
		rm -fr ecromedos-${tag})

	# fetch build artifacts
	mv $tmpdir/ecromedos-${tag}.tar.gz ${outdir}/tgz

	# cleanup
	rm -fr $tmpdir

	echo "done"
}

function build_deb #(tag, outdir)
{
	local tag=$1
	local outdir=$2
	local tmpdir="`mktemp -d`"

	echo -n "Building Debian package in $tmpdir..."

	# build orig-tarball
	git archive --prefix=ecromedos-${tag}/ --format=tar ${tag} | \
		(cd ${tmpdir} && \
		tar -x \
			--exclude=.gitignore \
			--exclude=debian \
			--exclude=ecromedos.spec \
			--exclude=package.sh -f - && \
		tar -czf ecromedos_${tag}.orig.tar.gz ecromedos-${tag} && \
		rm -fr ecromedos-${tag})

	# extract plain sources with debian-dir
	git archive --prefix=ecromedos-${tag}/ --format=tar ${tag} | \
		(cd ${tmpdir} && \
		tar -x \
			--exclude=.gitignore \
			--exclude=ecromedos.spec \
			--exclude=package.sh -f -)

	# build packages
	(cd ${tmpdir}/ecromedos-${tag} &&
		dpkg-buildpackage -us -uc &&
		cd .. &&
		mv *.{changes,deb,dsc,diff.gz,tar.gz} ${outdir}/deb)

	# cleanup
	rm -fr ${tmpdir}

	echo "done"
}

function check_version #(tag)
{
	local tag=$1

	if ! grep "VERSION = \"$tag\"" bin/ecromedos > /dev/null; then
		error $ERR_TAGNO "Wrong version number in bin/ecromedos."
	fi

	if ! grep "ecromedos Document Preparation System V${tag}" transform/shared/version.xsl > /dev/null; then
		error $ERR_TAGNO "Wrong version number in transform/shared/version.xsl."
	fi
}

###############################################################################

if [ $# -ne 2 ]; then
	usage
	exit $ERR_USAGE
fi

TAG=$1
OUTDIR=$2

# SANITY CHECKS
check_outdir $OUTDIR
check_tag $TAG
check_version $TAG

# GET ABS PATH FOR OUTDIR
OUTDIR="`echo $(cd ${OUTDIR} && pwd)`"

# MAKE SUBDIRS
mkdir $OUTDIR/{deb,tgz,rpm}

# BUILD PACKAGES
build_rpm $TAG $OUTDIR
build_tgz $TAG $OUTDIR
build_deb $TAG $OUTDIR

echo "Collect artifacts from $OUTDIR."

