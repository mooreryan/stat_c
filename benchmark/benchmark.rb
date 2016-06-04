require "stat_c"
require "benchmark"

def ary_mean ary
  ary.reduce(:+) / ary.length.to_f
end

# sample variance
def ary_var ary
  mean = ary_mean ary
  ary.map { |num| (num - mean) ** 2 }.reduce(:+) / (ary.length - 1)
end

def ary_sd ary
  Math.sqrt(ary_var ary)
end

def ary_se ary
  ary_sd(ary) / Math.sqrt(ary.length)
end

ary = (1..1_000_000).map(&:itself)

Benchmark.bmbm do |x|
  x.report("Ruby  mean") { ary_mean ary }
  x.report("StatC mean") { StatC::Array.mean ary }

  x.report("Ruby  var") { ary_var ary }
  x.report("StatC var") { StatC::Array.var ary }

  x.report("Ruby  sd") { ary_sd ary }
  x.report("StatC sd") { StatC::Array.sd ary }

  x.report("Ruby  se") { ary_se ary }
  x.report("StatC se") { StatC::Array.se ary }
end
