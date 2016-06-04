require "stat_c"
require "benchmark"

def mean ary
  ary.reduce(:+) / ary.length.to_f
end

ary = (1..1_000_000).map(&:itself)

Benchmark.bmbm do |x|
  x.report("ruby mean") do
    mean ary
  end

  x.report("c mean") do
    StatC::Array.mean ary
  end
end
