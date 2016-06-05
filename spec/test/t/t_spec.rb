# coding: utf-8
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

# For t stat and dof formulas:
# https://en.wikipedia.org/wiki/Welch%27s_t-test

require "spec_helper"

describe "StatC" do
  describe "Test" do
    describe "T" do
      describe "::t_stat_welch" do
        context "if both variances are zero" do
          it "raises StatC::Error::Error" do
            mean1 = mean2 = 5
            var1 = var2 = 0

            size1 = size2 = 1

            expect{StatC::Test::T.t_stat_welch(mean1, var1, size1,
                                               mean2, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        context "if size1 is not > 0" do
          it "raises StatC::Error::Error" do
            mean1 = mean2 = 5
            var1 = var2 = 1

            size1 = 0
            size2 = 1

            expect{StatC::Test::T.t_stat_welch(mean1, var1, size1,
                                               mean2, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        context "if size2 is not > 0" do
          it "raises StatC::Error::Error" do
            mean1 = mean2 = 5
            var1 = var2 = 1

            size1 = 1
            size2 = 0

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
          # print(t.test(ary1, ary2)$statistic, digits=15)
          expect(StatC::Test::T.t_stat_welch(mean1, var1, size1,
                                             mean2, var2, size2)).
            to be_within(SHelper::ALLOWED_ERR).
                of(-2.97730106103501)
        end
      end

      describe "::dof_welch" do
        context "if size1 <= 0" do
          it "raises StatC::Error::Error" do
            size1 = 0
            size2 = 32

            var1 = 234
            var2 = 82

            expect {StatC::Test::T.dof_welch(var1, size1, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        context "if size1 == 1" do
          it "raises StatC::Error::Error (divide by zero)" do
            size1 = 1
            size2 = 32

            var1 = 234
            var2 = 82

            expect {StatC::Test::T.dof_welch(var1, size1, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        context "if size2 <= 0" do
          it "raises StatC::Error::Error" do
            size1 = 35
            size2 = 0

            var1 = 234
            var2 = 82

            expect {StatC::Test::T.dof_welch(var1, size1, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        context "if size2 == 1" do
          it "raises StatC::Error::Error (divide by zero)" do
            size1 = 32
            size2 = 1

            var1 = 234
            var2 = 82

            expect {StatC::Test::T.dof_welch(var1, size1, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        context "if denom is zero" do
          it "raises StatC::Error::Error" do
            var1 = var2 = 0
            size1 = size2 = 10

            expect {StatC::Test::T.dof_welch(var1, size1, var2, size2)}.
              to raise_error(StatC::Error::Error)
          end
        end

        it "returns degrees of freedom estimated by the " +
           "Welch–Satterthwaite equation" do
          var1  = 2.3
          size1 = 5

          var2  = 1.282
          size2 = 5

          # print(tt$parameter, digits=15)
          expect(StatC::Test::T.dof_welch(var1, size1, var2, size2)).
            to be_within(SHelper::ALLOWED_ERR).
                of 7.40213721045748
        end
      end
    end
  end
end
