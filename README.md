# vpkg 
vpkg is an alternative package manager written on [V](https://github.com/vlang/v) for V.

## Features
Bringing the best of dependency management on V.
- **Decentralized.** Download and use packages from other sources aside from VPM and the vpkg registry.
- **Easy to use.** Set-up, use, and master the commands of vpkg CLI within minutes.
- **Fast.** Runs perfectly on your potato PC up to the fastest supercomputers.
- **Interoperable.** Supports `v.mod`, and `.vpm.json` for reading package manifests and managing dependencies.
- **Light.** Weighs at less than 300kb. Perfect with devices running on tight storage or in low network conditions.
- **Reliable.** Uses a lockfile mechanism to ensure that all your dependencies work across all of your machines.

## Installation
### Pre-built binaries
Install vpkg by downloading the pre-built binaries available found below the release notes of the [latest release](https://github.com/vpkg/releases).

### Building from Source
For those platforms which aren't included in the available pre-built binaries or would like to compile it by yourself, just clone this repository and build directly with the V compiler with the `-prod` flag.
```
git clone https://github.com/vpkg-project/vpkg.git
cd vpkg/
v -prod .
```

## Running your own registry
Use the provided [registry server template](https://github.com/vpkg-project/registry-template) to start running your own registry server. Just modify `registry.json` and use any http or web library of your choice to get up and running.

## Commands
```
Usage: vpkg <COMMAND> [ARGS...] [options]

COMMANDS

get [packages]                             Fetch and installs packages from the registry or the git repo.
help                                       Prints this help message.
info                                       Show project's package information.
init [--format=vpkg|vmod]                  Creates a package manifest file into the current directory. Defaults to "vpkg".
install                                    Reads the package manifest file and installs the necessary packages.
migrate manifest [--format=vpkg|vmod]      Migrate manifest file to a specified format.
remove [packages]                          Removes packages
update                                     Updates packages.
version                                    Prints the version of this program.

OPTIONS

--global, -g                               Installs the modules/packages into the `.vmodules` folder.
--force                                    Force download the packages.
```

## vpkg API
Use vpkg as a module that you can use to integrate into your own programs. Create your own VSH scripts, automate installation, and more without needing for a separate CLI program.

```v
// install.v
module main

import vpkg.api // or import nedpals.vpkg.api

fn main() {
	mut inst := api.new_vpkg('.')
	inst.run(['install'])

	os.system('rm ${os.executable()}')
}

```

```sh
$ v run install.v
Installing packages
Fetching nedpals.vargs

vargs@fc193513733c2ed99467f5d903a824ea9087ed52
1 package was installed successfully.
```

## Roadmap
- ability to publish packages into VPM and the vpkg registry.
- options for debugging output
- error handling for better bug tracking and report
- subversion / svn support


## Copyright
(C) 2019 [Ned Palacios](https://github.com/nedpals)
