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
  describe "Test" do
    describe "T" do
      describe "::t_stat_welch" do
        context "if the denominator is zero" do
          it "raises StatC::Error::Error" do
            mean1 = 0
            mean2 = 0

            var1 = 0
            var2 = 0

            size1 = 1
            size2 = 1

            expect{StatC::Test::T.t_stat_welch(mean1, var1, size1,
                                               mean2, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        it "gives Welch's t statistic" do
          mean1 = -0.1
          var1  = 2.3
          size1 = 5

          mean2 = 2.42
          var2  = 1.282
          size2 = 5

          # ary1 <- c(-1, -2, 0, 2, 0.5)
          # ary2 <- c(1, 2.1, 3, 2, 4)
          # print(t.test(ary1, ary2)$statistic, digits=16)
          expect(StatC::Test::T.t_stat_welch(mean1, var1, size1,
                                             mean2, var2, size2)).
            to be_within(SHelper::ALLOWED_ERR).
                of(-2.977301061035011)
        end
      end
    end
  end
end
