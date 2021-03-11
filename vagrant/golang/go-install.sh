#!/bin/bash
# ---------------------------------------------------------------------
#  simple script to download and install Go tools
# ---------------------------------------------------------------------

set -e

ARCH="amd64"
OS="linux"
VERSION="latest"

URL="${URL:-https://golang.org/dl}"
WORKDIR="${WORKDIR:-$PWD}"
INSTALLDIR="/usr/local"

# ---------------------------------------------------------------------

function dt    { date '+%Y, %h %d %H:%M:%S'; }
function log   { echo "> $*";                }
function error { echo; echo "* ERROR > $*"; echo; }
function fail  { local exit_code=${1}; shift 1; error $*; exit ${exit_code}; }

function usage() {
	cat << EOF

script to download and install Go toolchain

usage:

	$(basename $0) [ optional arguments ] <Go version>

	optional arguments:

		-a : architecture              (default=${ARCH})
		-d : installation directory    (default=${INSTALLDIR})
		-o : os                        (default=${OS})
		-h : print usage

EOF
	exit 1
}

function go_version() {
	local version="${1}"

	if [[ "${version}" == "latest" ]]; then
		version="$(curl -s https://golang.org/VERSION?m=text)"
		version="${version#go}"
	fi

	echo ${version}
}

function go_distfile() {
	local os="${1}"
	local arch="${2}"
	local version="${3}"

	case ${os} in
		linux)		distfile="go${version}.${os}-${arch}.tar.gz" ;;
		darwin)		distfile="go${version}.${os}-${arch}.pkg" ;;
		windows)	distfile="go${version}.${os}-${arch}.msi" ;;
		*)
			fail "unsupported os: ${os}"		
	esac

	echo ${distfile}
}

# ---------------------------------------------------------------------

while getopts "a:d:o:qh" opt; do
	case "${opt}" in
		a )         ARCH="${OPTARG}"    ;;
		d )         DIR="${OPTARG}"     ;;
		o )         OS="${OPTARG}"      ;;
		q )         QUIET="yes"         ;;
		h | * )     usage               ;;
	esac
done

shift $(( OPTIND -1 ))

if (( $# > 0 )); then
	VERSION=$1
fi

version="$(go_version ${VERSION})"
distfile="$(go_distfile ${OS} ${ARCH} ${version})"
download_file="${WORKDIR}/${distfile}"

log
if [[ ! -f "${download_file}" ]]; then
	log "download: $(basename ${distfile})"
	wget ${QUIET:+-nv} -t3 --progress=bar "${URL}/${distfile}" > /dev/null
fi

log "install:  ${INSTALLDIR}"
rm -rf ${INSTALLDIR}/go
tar -C ${INSTALLDIR} -zxf ${download_file}

log "update PATH:"
cat << EOF > /etc/profile.d/golang.sh
export PATH=\${PATH}:${INSTALLDIR}/go/bin
EOF

log
log "done"
log
