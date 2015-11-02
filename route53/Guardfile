# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, spec_paths: ["test/unit"] do
  watch(%r{^test/unit/.+_spec\.rb$})
  watch(%r{^(libraries|definitions|providers|recipes|resources)/(.+)\.rb$}) { |m| "test/unit/#{m[1]}/#{m[2]}_spec.rb" }
  watch("test/unit/spec_helper.rb")  { "test/unit" }
end

guard 'kitchen' do
  watch(%r{test/.+})
  watch(%r{^recipes/(.+)\.rb$})
  watch(%r{^attributes/(.+)\.rb$})
  watch(%r{^files/(.+)})
  watch(%r{^templates/(.+)})
  watch(%r{^providers/(.+)\.rb})
  watch(%r{^resources/(.+)\.rb})
  watch(%r{^libraries/(.+)\.rb})
end
