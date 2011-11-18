case node[:plattform]
  when "ubuntu"
    execute "add-apt-repository" do

    end
  end
  when "debian"
    if !File.exists?("/etc/sources.list.d/silverline.list") 

    end
  end
end
