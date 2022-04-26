#!/usr/bin/env python3

# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Ramses Composer
# (see https://github.com/bmwcarit/ramses-composer-docs).
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
# If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.

from pathlib import Path
import shutil
import os
import sys
import subprocess
import re


def get_git_files(path):
    """Get all files known to git"""
    cmd = ['git', 'ls-files', '-z']
    files = [f.decode('utf-8') for f in subprocess.check_output(cmd, cwd=path).split(b'\0') if f]
    return files


def filter_includes_excludes(iterable, *, includes=['.*'], excludes=[]):
    key_fun = (lambda e: e)
    include_re = re.compile('|'.join([f'(?:{i})'for i in includes]))
    exclude_re = re.compile('|'.join([f'(?:{e})'for e in excludes]))

    res = []
    for e in iterable:
        k = key_fun(e)
        if includes and include_re.search(k) and not (excludes and exclude_re.search(k)):
            res.append(e)
    return res


def copy_files(source_root, destination_root, files):
    for f in files:
        source_path = Path(source_root) / f
        destination_path = Path(destination_root) / f
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        if source_path.is_symlink():
            destination_path.unlink(missing_ok=True)
        shutil.copy(source_path, destination_path, follow_symlinks=False)


def main():
    script_dir = Path(os.path.realpath(os.path.dirname(__file__)))
    root_dir = (script_dir / '..').resolve()
    target_dir = root_dir / 'release'
    target_dir.mkdir(parents=True, exist_ok=True)

    source = root_dir
    destination = target_dir

    tutorials = set()

    for root, _dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".rca"):
                tutorial_path = (Path(root) / file).parents[0]
                tutorials.add(tutorial_path.relative_to(root_dir))

    tutorial_paths = [str(t.as_posix()) for t in tutorials]
    include_paths = tutorial_paths + [
        '^readme.md',
        '^LICENSE.txt',
    ]

    exclude_docs = [str((t / 'docs').as_posix()) for t in tutorials]
    exclude_readmes = [str((t / 'README.md').as_posix()) for t in tutorials]
    exclude_extra = [
        '.git*',
        'ramses-composer-logo.png',
    ]

    exclude_paths = exclude_docs + exclude_readmes + exclude_extra
    # gather source files
    source_files = get_git_files(source)
    source_files = filter_includes_excludes(source_files, includes=include_paths, excludes=exclude_paths)

    # copy source -> destination
    copy_files(source, destination, source_files)

    # Create zip archive
    archive_name = 'tutorials'
    if len(sys.argv) == 2:
        archive_name = sys.argv[1]
    shutil.make_archive(archive_name, 'zip', destination)


if __name__ == "__main__":
    main()
