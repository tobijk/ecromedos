#!/bin/bash

function usage {
	echo "Usage: debian/package.sh <tag>"
}

if [ $# -lt 1 ] || [ -z "`echo $0 | egrep '^debian/'`" ]; then
	usage
	exit 1
fi

TAG=$1
OLD_BRANCH=`git branch | egrep "^\*" | cut -d' ' -f2`

git checkout $TAG > /dev/null 2>&1 || {
	echo "Could not check out tag $TAG."
	exit 2
}

git checkout $OLD_BRANCH > /dev/null 2>&1

git archive --prefix=ecromedos-${TAG}/ --format=tar ${TAG} | \
	(cd .. && \
	tar -x --exclude=.gitignore --exclude=debian -f - && \
	tar -czf ecromedos-${TAG}.orig.tar.gz ecromedos-${TAG} \
	&& rm -fr ecromedos-${TAG})

git archive --prefix=ecromedos-${TAG}/ --format=tar pkg | \
	(cd .. && tar -x --exclude=.gitignore -f -)

