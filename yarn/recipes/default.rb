case node['platform']
when 'debian', 'ubuntu'
  bash 'Add the signing key and desired repo' do
    cwd '/tmp'
    code <<-EOH
    curl -sS #{node['yarn']['package']['key']} | sudo apt-key add -
    echo "deb #{node['yarn']['package']['uri']} #{node['yarn']['package']['distribution']} main" | sudo tee /etc/apt/sources.list.d/yarn.list
    EOH
  end

  execute "apt-get update" do
    command "apt-get update"
  end

  apt_package 'yarn'
else
  raise "Unsupported platform: #{node['platform']}"
end
