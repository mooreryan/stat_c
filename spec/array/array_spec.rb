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

# @note all the required values are checked against R with
#   print(method(ary), digits=22)

describe StatC do
  describe Array do
    shared_examples "when passed an empty array" do |method|
      context "when passed an empty array" do
        it "raises StatC::Error::Error" do
          expect { StatC::Array.send method, [] }.
            to raise_error StatC::Error::Error
        end
      end
    end

    describe "::mean" do
      include_examples "when passed an empty array", :mean

      context "when passed an array of numbers" do
        it "gives the mean -- R: mean(ary)" do
          expect(StatC::Array.mean [-1.4, 0, 1, 2, 3.0]).
            to be_within(SHelper::ALLOWED_ERR).
                of(0.920000000000000039968)
        end
      end
    end

    describe "::var" do
      include_examples "when passed an empty array", :var

      context "when passed an array of numbers with default arg" do
        it "gives the sample variance -- R: var(ary)" do
          expect(StatC::Array.var [-1.4, 0, 1, 2, 3.0]).
            to be_within(SHelper::ALLOWED_ERR).
                of(2.931999999999999939604)
        end
      end

      context "when pop is true" do
        it "gives the population variance" do
          expect(StatC::Array.var [-1.4, 0, 1, 2, 3.0], pop=true).
            to be_within(SHelper::ALLOWED_ERR).
                of(2.345600000000000129319)
        end
      end
    end

    describe "::sd" do
      include_examples "when passed an empty array", :sd

      context "when passed an array of numbers with default arg" do
        it "gives the sample standard deviation -- R: sd(ary)" do
          expect(StatC::Array.sd [-1.4, 0, 1, 2, 3.0]).
            to be_within(SHelper::ALLOWED_ERR).
                of(1.712308383440319436986)
        end
      end

      context "when pop is true" do
        it "gives the population std dev" do
          expect(StatC::Array.sd [-1.4, 0, 1, 2, 3.0], pop=true).
            to be_within(SHelper::ALLOWED_ERR).
                of(1.531535177526131885628)
        end
      end
    end

    describe "::se" do
      include_examples "when passed an empty array", :sd

      context "when passed an array of numbers with default arg" do
        it "gives the sample standard error of the mean" do
          expect(StatC::Array.se [-1.4, 0, 1, 2, 3.0]).
            to be_within(SHelper::ALLOWED_ERR).
                of(0.7657675887630658317917)
        end
      end

      context "when pop is true" do
        it "gives the population s.e.m." do
          expect(StatC::Array.se [-1.4, 0, 1, 2, 3.0], pop=true).
            to be_within(SHelper::ALLOWED_ERR).
                of(0.6849233533761277525898)
        end
      end
    end
  end
end
