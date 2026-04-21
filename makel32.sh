#                      Pool of Radiance Config
#
# Copyright 2026 Bloodbat / La Serpiente y la Rosa Producciones
#
# Pool of Radiance Config is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# Pool of Radiance Config is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Pool of Radiance Config. If not, see <http://www.gnu.org/licenses/>.
#
# This script file cross compiles the Pool of Radiance Config binary program
# for 32-bit Linux.

#!/bin/sh

lazbuild --bm="Release Linux x32" config.lpi
