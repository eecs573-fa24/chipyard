#!/usr/bin/env bash

# exit script if any command fails
set -e
set -o pipefail

RDIR=$(git rev-parse --show-toplevel)

# get helpful utilities
source $RDIR/scripts/utils.sh

common_setup

function usage
{
    echo "Usage: $0 [--force]"
    echo "Initialize Chipyard submodules and setup initial env.sh script."
    echo ""
    echo "  --force -f      : Skip prompt checking for tagged release"
    echo "  --skip-validate : DEPRECATED: Same functionality as --force"
}

FORCE=false
while test $# -gt 0
do
   case "$1" in
        --force | -f | --skip-validate)
            FORCE=true;
            ;;
        -h | -H | --help | help)
            usage
            exit 1
            ;;
        *)
            echo "ERROR: bad argument $1"
            usage
            exit 2
            ;;
    esac
    shift
done

# check that git version is at least 1.7.8
MYGIT=$(git --version)
MYGIT=${MYGIT#'git version '} # Strip prefix
case ${MYGIT} in
    [1-9]*)
        ;;
    *)
        echo "WARNING: unknown git version"
        ;;
esac
MINGIT="1.8.5"
if [ "$MINGIT" != "$(echo -e "$MINGIT\n$MYGIT" | sort -V | head -n1)" ]; then
  echo "This script requires git version $MINGIT or greater. Exiting."
  exit 4
fi

# before doing anything verify that you are on a release branch/tag
save_bash_options
set +e
git_tag=$(git describe --exact-match --tags)
git_tag_rc=$?
restore_bash_options
if [ "$git_tag_rc" -ne 0 ]; then
    if [ "$FORCE" == false ]; then
        while true; do
            read -p "WARNING: You are not on an official release of Chipyard."$'\n'"Type \"y\" to continue if this is intended or \"n\" if not: " validate
            case "$validate" in
                y | Y)
                    echo "Continuing on to setting up non-official Chipyard release repository"
                    break
                    ;;
                n | N)
                    error "See https://chipyard.readthedocs.io/en/stable/Chipyard-Basics/Initial-Repo-Setup.html#setting-up-the-chipyard-repo for setting up an official release of Chipyard. "
                    exit 3
                    ;;
                *)
                    error "Invalid response. Please type \"y\" or \"n\""
                    ;;
            esac
        done
    fi
else
    echo "Setting up official Chipyard release: $git_tag"
fi

cd "$RDIR"

(
    # Blocklist of submodules to initially skip:
    # - Toolchain submodules
    # - Generators with huge submodules (e.g., linux sources)
    # - FireSim until explicitly requested
    # - Hammer tool plugins
    git_submodule_exclude() {
        # Call the given subcommand (shell function) on each submodule
        # path to temporarily exclude during the recursive update
        for name in \
            toolchains/*-tools/* \
            toolchains/libgloss \
            generators/sha3 \
            generators/gemmini \
            sims/firesim \
            software/nvdla-workload \
            software/coremark \
            software/firemarshal \
            software/spec2017 \
            vlsi/hammer-cadence-plugins \
            vlsi/hammer-synopsys-plugins \
            vlsi/hammer-mentor-plugins \
            fpga/fpga-shells
        do
            "$1" "${name%/}"
        done
    }

    _skip() { git config --local "submodule.${1}.update" none ; }
    _unskip() { git config --local --unset-all "submodule.${1}.update" || : ; }

    trap 'git_submodule_exclude _unskip' EXIT INT TERM
    (
        set -x
        git_submodule_exclude _skip
        git submodule update --init --recursive #--jobs 8
    )
)

(
    # Non-recursive clone to exclude riscv-linux
    git submodule update --init generators/sha3

    # Non-recursive clone to exclude gemmini-software
    git submodule update --init generators/gemmini
    git -C generators/gemmini/ submodule update --init --recursive software/gemmini-rocc-tests

    # Minimal non-recursive clone to initialize sbt dependencies
    git submodule update --init sims/firesim
    git config --local submodule.sims/firesim.update none

    # Only shallow clone needed for basic SW tests
    git submodule update --init software/firemarshal
)

# Configure firemarshal to know where our firesim installation is
if [ ! -f ./software/firemarshal/marshal-config.yaml ]; then
  echo "firesim-dir: '../../sims/firesim/'" > ./software/firemarshal/marshal-config.yaml
fi

cat << EOT >> env.sh
# line auto-generated by init-submodules-no-riscv-tools.sh
__DIR="$RDIR"
PATH=\$__DIR/bin:\$PATH
PATH=\$__DIR/software/firemarshal:\$PATH
EOT
