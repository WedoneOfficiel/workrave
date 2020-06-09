case "$WORKRAVE_ENV" in
    local)
        echo "Running locally"
        WORKSPACE=/workspace
        OUTPUT_DIR=${WORKSPACE}/output
        SOURCES_DIR=${WORKSPACE}/source
        DEPLOY_DIR=${WORKSPACE}/deploy
        SECRETS_DIR=${WORKSPACE}/secrets
        PREBUILT_DIR=${WORKSPACE}/prebuilt
        CI_DIR=${WORKSPACE}/ci

        BUILD_DIR=${SOURCES_DIR}/_dist/build
        ;;

    travis)
        echo "Running on Travis"
        WORKSPACE=/workspace
        OUTPUT_DIR=${WORKSPACE}/output
        SOURCES_DIR=${WORKSPACE}/source
        DEPLOY_DIR=${SOURCES_DIR}/_deploy
        BUILD_DIR=${SOURCES_DIR}/_dist/build
        SECRETS_DIR=${SOURCES_DIR}/_dist/secrets
        PREBUILT_DIR=${WORKSPACE}/prebuilt
        CI_DIR=${SOURCES_DIR}/build/ci
        ;;

    github-docker)
        echo "Running on Github in docker"
        WORKSPACE=/workspace
        SOURCES_DIR=${WORKSPACE}/source
        OUTPUT_DIR=${WORKSPACE}/output
        DEPLOY_DIR=${SOURCES_DIR}/_deploy
        BUILD_DIR=${SOURCES_DIR}/_dist/build
        PREBUILT_DIR=${WORKSPACE}/prebuilt
        CI_DIR=${SOURCES_DIR}/build/ci
        ;;

    github)
        echo "Running on Github"
        WORKSPACE=$GITHUB_WORKSPACE
        SOURCES_DIR=${WORKSPACE}
        OUTPUT_DIR=${WORKSPACE}/output
        DEPLOY_DIR=${SOURCES_DIR}/_deploy
        BUILD_DIR=${SOURCES_DIR}/_dist/build
        PREBUILT_DIR=${WORKSPACE}/prebuilt
        CI_DIR=${SOURCES_DIR}/build/ci
        ;;
    *)
        echo "Unknown environment"
       ;;
esac

ISCC=${WORKSPACE}/inno/app/ISCC.exe
MINGW_MAKE_RUNTIME=${CI_DIR}/mingw-make-runtime.sh
MINGW_ENV=${CI_DIR}/mingw-env

export DEBFULLNAME="Rob Caelers"
export DEBEMAIL="robc@krandor.org"
export WORKRAVE_PPA=ppa:rob-caelers/workrave-snapshots

cd ${SOURCES_DIR}

export WORKRAVE_GIT_TAG=`git describe --abbrev=0`
export WORKRAVE_GIT_VERSION=`git describe --tags --abbrev=10 2>/dev/null | sed -e 's/-g.*//'`
export WORKRAVE_LONG_GIT_VERSION=`git describe --tags --abbrev=10 2>/dev/null`
export WORKRAVE_VERSION=`echo $WORKRAVE_GIT_VERSION | sed -e 's/_/./g' | sed -e 's/-/./g'`
export WORKRAVE_COMMIT_COUNT=`git rev-list ${WORKRAVE_GIT_TAG}..HEAD --count`
export WORKRAVE_COMMIT_HASH=`git rev-parse HEAD`
export WORKRAVE_BUILD_DATE=`date +"%Y%m%d"`
export WORKRAVE_BUILD_DATETIME=`date --iso-8601=seconds`
export WORKRAVE_BUILD_ID="$WORKRAVE_BUILD_DATE-$WORKRAVE_LONG_GIT_VERSION"
export WORKRAVE_UPLOAD_DIR="snapshots/v1.10/$WORKRAVE_BUILD_ID"

if [ $WORKRAVE_GIT_VERSION != $WORKRAVE_GIT_TAG ]; then
    echo "Snapshot build ($WORKRAVE_GIT_VERSION) of release ($WORKRAVE_GIT_TAG)"
fi


case "$WORKRAVE_ENV" in
    local)
        export WORKRAVE_JOB_NUMBER=$WORKRAVE_BUILD_ID
        ;;

    travis)
        export WORKRAVE_JOB_NUMBER=$TRAVIS_JOB_NUMBER
        export DEPLOY_DIR=$DEPLOY_DIR/$WORKRAVE_BUILD_ID
        ;;

    github-docker)
        export WORKRAVE_JOB_NUMBER=gh${GITHUB_RUN_ID}.${WORKRAVE_JOB_INDEX}
        export DEPLOY_DIR=$DEPLOY_DIR/$WORKRAVE_BUILD_ID
        ;;

    github)
        export WORKRAVE_JOB_NUMBER=gh${GITHUB_RUN_ID}.${WORKRAVE_JOB_INDEX}
        export DEPLOY_DIR=$DEPLOY_DIR/$WORKRAVE_BUILD_ID

    *)
        echo "Unknown environment"
        ;;
esac


