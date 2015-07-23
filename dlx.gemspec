# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "dlx"
  spec.version       = '0.0.2'
  spec.date          = '2015-07-23'
  spec.authors       = ["Sam Davis"]
  spec.email         = ["sam@samgd.com"]

  spec.summary       = "Dancing Links"
  spec.description   = "Dancing Links - Finding all solutions to the exact cover problem"
  spec.homepage      = "https://github.com/samgd/dlx"
  spec.license       = "MIT"
  spec.files         = ["lib/dlx/node.rb", "lib/dlx/header.rb", "lib/dlx/sparse_matrix.rb"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
