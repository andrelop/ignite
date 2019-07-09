#!/bin/bash

SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
cd ${SCRIPT_DIR}/..

git checkout master

FORCE=${FORCE:-0}
GENERATED_GIT_VERSION=$(hack/ldflags.sh --version-only)

if [[ ${GENERATED_GIT_VERSION} =~ "-dirty" && ${FORCE} == 0 ]]; then
    echo "Won't try to do a release when the git state is dirty"
    exit 1
fi

MAJOR=${MAJOR:-0}
MINOR=${MINOR:-0}
PATCH=${PATCH:-0}
VERSION="v${MAJOR}.${MINOR}.${PATCH}"
RELEASE_BRANCH="release-${MAJOR}.${MINOR}"
EXTRA=${EXTRA:-""}
FULL_VERSION=${VERSION}${EXTRA}

if [[ ${MINOR} == "0" ]]; then
    echo "MINOR is mandatory"
    exit 1
fi

echo "Releasing version ${FULL_VERSION}"

make_tidy_autogen() {
    make tidy
    make autogen
    if [[ $(git status --short) != "" ]]; then
        git add -A
        git commit -m "Run make tidy and make autogen"
    fi
}

write_changelog() {
    file="CHANGELOG.md"
    echo '<!-- Note: This file is autogenerated based on files in docs/releases. Run hack/release.sh to update -->' > ${file}
    echo "" >> ${file}
    echo "# Changelog" >> ${file}
    echo "" >> ${file}
    for release in $(find docs/releases/ -type f | sort -r); do
        cat ${release} >> ${file}
        echo "" >> ${file}
    done
    read -p "Are you sure you want to do a commit for the changelog? [y/N] " confirm
    if [[ ${confirm} != "Y" ]]; then
        exit 1
    fi

    git add -A
    git commit -m "Release ${FULL_VERSION}"
}

tag_release() {
    read -p "Are you sure you want to tag the release ${FULL_VERSION}? [y/N] " confirm
    if [[ ${confirm} != "Y" ]]; then
        exit 1
    fi

    git checkout -b ${RELEASE_BRANCH}
    git tag ${FULL_VERSION}
}

build_artifacts() {
    make ignite
    make ignite-spawn
    mkdir -p bin/releases/${FULL_VERSION}
    cp bin/ignite bin/releases/${FULL_VERSION}
    make -C images build-all
}

push_artifacts() {
    read -p "Are you sure you want to push the release ${FULL_VERSION} artifacts? [y/N] " confirm
    if [[ ${confirm} != "Y" ]]; then
        cat <<EOF
Done! Next, do this:

make -C images push-all
make image-push
git push --tags
git push origin ${RELEASE_BRANCH}
git push origin master
EOF
        exit 1
    fi
    make -C images push-all
    make image-push
    git push --tags
    git push origin ${RELEASE_BRANCH}
    git push origin master
}

if [[ $1 == "tidy" ]]; then
    make_tidy_autogen
elif [[ $1 == "changelog" ]]; then
    write_changelog
elif [[ $1 == "tag" ]]; then 
    tag_release
elif [[ $1 == "build" ]]; then 
    build_artifacts
elif [[ $1 == "push" ]]; then 
    push_artifacts
elif [[ $1 == "all" ]]; then
    make_tidy_autogen
    write_changelog
    tag_release
    build_artifacts
    push_artifacts
else
    echo "Usage: $0 [command]"
    echo "Command can be tidy, changelog, tag, build or push."
    echo "Alternatively, 'all' can be specified to do all phases in one."
    echo "To set the version to use, specify the MAJOR, MINOR, PATCH, and EXTRA environment variables"
fi
