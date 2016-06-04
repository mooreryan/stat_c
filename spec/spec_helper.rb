# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of StatC.
#
# StatC is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# StatC is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
# License for more details.
#
# You should have received a copy of the GNU General Public License
# along with StatC.  If not, see <http://www.gnu.org/licenses/>.

require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'stat_c'

module SHelper
  # 1e-16 forces use of long double in C code
  ALLOWED_ERR = 1e-16
end
