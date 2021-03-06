module api

import (
    os
    filepath
)

struct Package {
    name string = ''
    url string = ''
    method string = ''
}

struct InstalledPackage {
mut:
    name string
    path string
    version string
    url string
    latest_commit string
    method string
}

fn fetch_from_sources(name string, install_location string, sources []string) InstalledPackage {
    mut pkg := Package{}
    mut dl_pkg := InstalledPackage{}

    for registry_url in sources {
        pkg = if registry_url == 'vpm' { 
            new_vpm('https://vpm.best', '/jsmod').search(name)
        } else { 
            new_registry(registry_url, '/registry.json').search(name)
        }

        if pkg.name.len == 0 {
            continue
        } else {
            break
        }
    }

    if pkg.method.len != 0 {
        fetch_pkg := FetchMethod{download_url: pkg.url, dir: install_location, args: []}
        dl_pkg = fetch_pkg.dl_package(pkg.method)
    }

    return dl_pkg
}

pub fn (vpkg Vpkg) fetch_package(path_or_name string) InstalledPackage {
    pkg_name := package_name(path_or_name)
    print('Fetching ${pkg_name}')
    exists_on_vlib := os.exists(filepath.join(GlobalModulesDir, pkg_name))
    exists_on_cwd := os.exists(filepath.join(vpkg.install_dir, pkg_name))
    module_install_path := if exists_on_cwd && !vpkg.is_global { vpkg.install_dir } else { GlobalModulesDir }
    install_location := if vpkg.is_global { GlobalModulesDir } else { vpkg.install_dir }
    mut data := InstalledPackage{}


    if (exists_on_vlib && vpkg.is_global) || (exists_on_cwd && !('force' in vpkg.options)) {
        installed_path := filepath.join(module_install_path, pkg_name)
        fetch_from_path := FetchMethod{ dir: installed_path }

        println('${pkg_name} is already installed.')
        
        pkg_manifest := load_manifest_file(installed_path)
        data = InstalledPackage{
            name: if pkg_manifest.name.len != 0 { pkg_manifest.name } else { pkg_name },
            path: installed_path,
            version: if pkg_manifest.version.len != 0 { pkg_manifest.version } else { fetch_from_path.check_version('git') },
            latest_commit: fetch_from_path.check_version('git'),
            method: ''
        }
    } else {
        if is_git_url(path_or_name) {
            fetch_from_url := FetchMethod{download_url: path_or_name, dir: install_location, args: []}
            data = fetch_from_url.dl_package('git')
        } else {
            mut sources := []string

            if !('use-builtin' in vpkg.options) || vpkg.options['use-builtin'] != 'false' {
                sources << ['vpm', 'https://vpkg-project.github.io/registry/']
            }

            for custom_source in vpkg.manifest.sources {
                if sources.index(custom_source) == -1 {
                    sources << custom_source
                }
            }

            data = fetch_from_sources(path_or_name, install_location, sources)
        }

        if data.name.len == 0 {
            println('Package \'${path_or_name}\' not found.')
        }
    }

    return data
}