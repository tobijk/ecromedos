#!/bin/bash

function usage {
	echo "Usage: package.sh <tag> <outdir>"
}

if [ $# -ne 2 ] || [ ! -f ecromedos.spec ]; then
	usage
	exit 1
fi

TAG=$1
OUTDIR=$2
OLD_BRANCH=`git branch | egrep "^\*" | cut -d' ' -f2`
TMPDIR="`mktemp -d`"

test -d ${OUTDIR} || {
	echo "No such directory '$OUTDIR'."
	exit 2
}

OUTDIR=$(cd ${OUTDIR} && pwd)

git checkout $TAG > /dev/null 2>&1 || {
	echo "Could not check out tag $TAG."
	exit 3
}

git checkout $OLD_BRANCH > /dev/null 2>&1

echo "Building package in $TMPDIR:"

mkdir -p $TMPDIR/{RPMS,BUILD,SOURCES,SPECS,SRPMS}

git archive --prefix=ecromedos-${TAG}/ --format=tar ${TAG} | \
	(cd ${TMPDIR}/SOURCES && \
	tar -x --exclude=.gitignore --exclude=debian --exclude=ecromedos.spec --exclude=package.sh -f - && \
	tar -czf ecromedos-${TAG}.tar.gz ecromedos-${TAG} \
	&& rm -fr ecromedos-${TAG})

cat ecromedos.spec | sed "s/###TAG###/$TAG/" > $TMPDIR/SPECS/ecromedos-${TAG}.spec
rpmbuild --target="noarch" --define="%_topdir $TMPDIR" -ba $TMPDIR/SPECS/ecromedos-${TAG}.spec
mv $TMPDIR/RPMS/*/*.rpm $OUTDIR
mv $TMPDIR/SRPMS/*.rpm $OUTDIR
rm -fr $TMPDIR

echo "Collect package from $OUTDIR."

