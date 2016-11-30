# Foodcritic Custom rules as a preparation for the Chef12 move.
#
# Since node[deploy], node[opsworks] and opsworks_* will be gone in Chef12,
# we are relocating everything using this in easybib_deploy, easybib/libraries/* and the wt-data cookbook
# so that we then have one single point for each case we have to readjust for Chef12.

rule 'WT001', 'Don\'t use opsworks_ definition calls outside the easybib deploy provider' do
  tags %w(bug wt)
  cookbook do |path|
    recipes  = Dir["#{path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
    recipes += Dir["#{path}/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)

      lines.collect.with_index do |line, index|
        if line.match('^( *)opsworks_') && recipe != 'easybib/providers/deploy.rb'
          {
            :filename => recipe,
            :matched => recipe,
            :line => index + 1,
            :column => 0
          }
        end
      end.compact
    end.flatten
  end
end

rule 'WT002', 'Don\'t use node[opsworks] outside the easybib library wrappers' do
  tags %w(bug wt)
  cookbook do |path|
    recipes  = Dir["#{path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
    recipes += Dir["#{path}/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)

      lines.collect.with_index do |line, index|
        if line.match('node\[(\'|"|:*)opsworks') && !recipe.match('^easybib/libraries')
          {
            :filename => recipe,
            :matched => recipe,
            :line => index + 1,
            :column => 0
          }
        end
      end.compact
    end.flatten
  end
end

rule 'WT003', 'Don\'t use node[deploy] outside the easybib & wt-data library wrappers' do
  tags %w(bug wt)
  cookbook do |path|
    recipes  = Dir["#{path}/{#{standard_cookbook_subdirs.join(',')}}/**/*.rb"]
    recipes += Dir["#{path}/*.rb"]
    recipes.collect do |recipe|
      lines = File.readlines(recipe)

      lines.collect.with_index do |line, index|
        if line.match('node\[(\'|"|:*)deploy') && !recipe.match('^easybib/libraries') && !recipe.match('^wt-data')
          {
            :filename => recipe,
            :matched => recipe,
            :line => index + 1,
            :column => 0
          }
        end
      end.compact
    end.flatten
  end
end
