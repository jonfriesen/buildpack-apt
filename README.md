# buildpack-apt

This is a [Cloud Native Buildpack](https://buildpacks.io/) that adds support for `apt`-based dependencies during both build and runtime.

This buildpack is inspired by the [fagiani/apt-buildpack](https://github.com/fagiani/apt-buildpack) and [heroku-buildpack-apt](https://github.com/heroku/heroku-buildpack-apt).


## Usage

This buildpack is not meant to be used on its own, and instead should be in used in combination with other buildpacks. If adding to your own builder image this should be near the top of the buildpack stack.

Include a list of `apt` package names to be installed in a file named `Aptfile`; be aware that line ending should be LF, not CRLF.

#### Debugging
Include a environment variable with any value and a name of `BUILDPACK_APT_DEBUG` to enable bash debugging verboseness.

## Example
The buildpack automatically downloads and installs the packages when you run a build:

#### Command-line

To use the latest stable version:
```bash
$ pack build --buildpack jonfriesen/apt myapp
```

To use a specific version:
```bash
# pack build --buildpack https://jon-buildpacks.nyc3.digitaloceanspaces.com/buildpack-apt-<version>.tgz
```

#### Aptfile

    # you can list packages
    libexample-dev

    # or include links to specific .deb files
    http://downloads.sourceforge.net/project/wkhtmltopdf/0.12.1/wkhtmltox-0.12.1_linux-precise-amd64.deb

    # or add custom apt repos (only required if using packages outside of the standard Ubuntu APT repositories)
    :repo:deb http://cz.archive.ubuntu.com/ubuntu artful main universe

