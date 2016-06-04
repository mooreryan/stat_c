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

require "spec_helper"

describe "StatC" do
  describe "Error" do
    describe "Error" do
      it "is a StandardError" do
        err = StatC::Error::Error.new
        expect(err).to be_a StandardError
      end
    end
  end
end
