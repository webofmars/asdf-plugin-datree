# asdf-plugin-datree [![Build](https://github.com/asdf-vm/asdf-plugin-datree/actions/workflows/build.yml/badge.svg)](https://github.com/asdf-vm/asdf-plugin-datree/actions/workflows/build.yml) [![Lint](https://github.com/asdf-vm/asdf-plugin-datree/actions/workflows/lint.yml/badge.svg)](https://github.com/asdf-vm/asdf-plugin-datree/actions/workflows/lint.yml)

## Usage

1. install asdf
2. asdf plugin add https://github.com/webofmars/asdf-plugin-datree
3. asdf plugin update --all
4. asdf install datree latest

## Contributing

Contributions welcome!

1. Install `asdf` tools
    ```shell
    asdf plugin add shellcheck https://github.com/luizm/asdf-shellcheck.git
    asdf plugin add shfmt https://github.com/luizm/asdf-shfmt.git
    asdf install
    ```
1. Develop!
1. Lint & Format
    ```shell
    ./scripts/shellcheck.bash
    ./scripts/shfmt.bash
    ```
1. PR changes
