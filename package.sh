#!/bin/bash

###############################################################################

ERR_USAGE=1
ERR_NOTAG=2
ERR_NODIR=3

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
	#end if
}

function check_outdir #(outdir)
{
	local outdir=$1

	# check for existence
	test -d "$outdir" || {
		echo "No such directory '$outdir'."
		exit $ERR_NODIR
	}

	# return abs path
	echo $(cd ${outdir} && pwd)
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
	rpmbuild --nodeps --target="noarch" --define="%_topdir $tmpdir" \
		-ba $tmpdir/SPECS/ecromedos-${tag}.spec

	# fetch build artifacts
	mv $tmpdir/RPMS/*/*.rpm $outdir
	mv $tmpdir/SRPMS/*.rpm $outdir

	# cleanup
	rm -fr $tmpdir

	echo "done"
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

# BUILD PACKAGES
build_rpm $TAG $OUTDIR

echo "Collect artifacts from $OUTDIR."

