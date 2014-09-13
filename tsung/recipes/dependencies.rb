include_recipe "nginx-app::server"

[
  "gnuplot-nox",
  "libtemplate-perl",
  "libhtml-template-perl",
  "libhtml-template-expr-perl",
  "erlang-nox"
].each do |package_name|
  package package_name
end 
