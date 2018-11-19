# hippo-sh-tools
Command line tools for release preparation automation

## Getting Started

### Prerequisites
These tools should be ran in a bash environment. Recommended to use [Git Bash](https://git-scm.com) when using Windows.

### Installation
```
# Clone this repo
git clone https://github.com/jenskooij/hippo-sh-tools.git
# Add to path
PATH=$PATH:$(pwd)/hippo-sh-tools
# Run
release-prepare.sh
```

_Note:_ In case of Windows, you will want to add the source directory of hippo-sh-tools to your Path environment variable through the Windows interface.

It's also possible to create an alias for the executable, in your ~/.bashrc by adding the following line:
```
alias prepare-release='/path/to/source/hippo-sh-tools/prepare-release.sh'
```

### Usage of individual tools
Run tools from bash

#### Version Bump
```
$ ./version-bump.sh new_version
```

#### Upgrade Bootstrap
```
$ ./upgrade-bootstrap.sh old_version new_version
```

#### Release Prepare
```
$ ./prepare-release.sh
```

## Authors

* **Jens Kooij** - *Initial work* - [jenskooij](https://github.com/jenskooij)

See also the list of [contributors](https://github.com/jenskooij/hippo-sh-tools) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details