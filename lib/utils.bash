#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for datree.
GH_REPO="https://github.com/datreeio/datree"
TOOL_NAME="datree"
TOOL_TEST="datree"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if datree is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if datree has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"
  os=get_os
  arch=get_arch

  # TODO: Adapt the release URL convention for datree
  #  datree-cli_1.6.37_Darwin_arm64.zip
  archive_file="$TOOL_NAME-cli_${version}_${os}_${arch}.zip"
  # https://github.com/datreeio/datree/releases/download/1.6.37/datree-cli_1.6.37_Darwin_arm64.zip
  url="$GH_REPO/releases/download/${version}/$archive_file"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    # TODO: Assert datree executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}

get_arch() {
  local arch
  arch="$(uname -m)"

  case "$arch" in
  x86_64)
    echo "amd64"
    ;;
  armv6l)
    echo "armv6"
    ;;
  armv7l)
    echo "armv7"
    ;;
  aarch64)
    echo "arm64"
    ;;
  *)
    fail "Unsupported architecture: $arch"
    ;;
  esac
}

get_os() {
  local os
  os="$(uname -s)"

  case "$os" in
  Linux)
    echo "linux"
    ;;
  Darwin)
    echo "darwin"
    ;;
  *)
    fail "Unsupported operating system: $os"
    ;;
  esac
}
