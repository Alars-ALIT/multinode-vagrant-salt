Vagrant.configure("2") do |config|
    config.vm.box = 'docker-vagrant'
	config.vm.box_url = 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box'
	
	config.vm.define "master" do |master|
		master.vm.hostname = "master"
		master.vm.network :private_network, ip: "10.1.1.2"
		master.vm.network "public_network", :bridge => 'en0: Ethernet (AirPort)'
		master.vm.synced_folder "salt", "/srv/salt/"
		master.vm.provision :salt do |salt|
			salt.master_config = "salt/configs/master.conf"
			salt.install_master = true
			salt.master_key = "salt/key/master.pem"
			salt.master_pub = "salt/key/master.pub"
			salt.seed_master = {minion: "salt/key/minion.pub"}
			
		end
	end
	
	(1..2).each do |i|
		config.vm.define "minion-0#{i}" do |minion|
			ip = i + 2
			minion.vm.hostname = "minion-0#{i}"
			minion.vm.network :private_network, ip: "10.1.1.#{ip}"
			minion.vm.network "public_network", :bridge => 'en0: Ethernet (AirPort)'
			minion.vm.synced_folder "salt/roots", "/srv/salt/"
			minion.vm.provision :salt do |salt|
				salt.minion_config = "salt/configs/minion.conf"
				salt.minion_key = "salt/key/minion.pem"
				salt.minion_pub = "salt/key/minion.pub"
				salt.run_highstate = true
			end	
		end
	end
  end