<!--
SPDX-License-Identifier: MPL-2.0

This file is part of Ramses Composer
(see https://github.com/GENIVI/ramses-composer-docs).

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

# Ramses Composer versions and dependencies

|Ramses Composer   |Ramses     |Ramses Logic|Date    |Notes                                                 |
|------------------|-----------|------------|--------|------------------------------------------------------|
|0.8.1             |27.0.103   |0.6.1       |06.2021 | Latest supported release, first open source release  |
|0.7.3             |27.0.101   |0.5.3       |04.2021 |                                                      |


# Switching to a newer version of the Composer (Project files)

The Ramses Composer is designed to be backwards compatible. Loading an older file into a newer version of the Composer
should not cause any data loss, and the scenes should produce the same visual result and behavior.

However, the file format is not forward-compatible, meaning that once you save a file with a newer version of the Composer,
older versions of the tool won't be able to open it any more.

# Ramses Dependencies (Runtime)

The Ramses Composer has an API and ABI dependency on the [Ramses Engine](https://github.com/GENIVI/ramses) and
the [Ramses Logic Engine](https://github.com/GENIVI/ramses-logic). This means that an upgrade to a newer version
of the composer which also includes a major update of any of the Ramses dependencies will require a re-export
of existing binary files, and also an upgrade of the engine/lib versions in your native code. In general, we invest
a lot of effort to make this process as smooth and transparent as possible - but we ask for understanding that using
newer features sometimes requires also updating your code slightly.

# Custom versions

The above table lists the officially supported combinations of the Composer, Ramses and the Ramses Logic Engine.
You can substitute any (newer!) non-major-version of the Ramses dependencies, and in some cases also use an older
patch version. We advise against doing this, unless you have a good reason for it!
