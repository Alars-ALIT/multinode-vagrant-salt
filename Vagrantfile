MASTER_IP = "10.1.1.3"

$bootstrapMinion = <<SCRIPT
echo "#{MASTER_IP} salt" >> /etc/hosts
hostname `cat /etc/hostname`
echo Updated hosts entry for 'salt' to #{MASTER_IP}
apt-get install -y python-pip
pip install docker-py
SCRIPT

$bootstapMaster = <<SCRIPT
apt-get install -y python-git
echo Installed python-git on master
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = 'docker-vagrant'
	config.vm.box_url = 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box'
	
	config.vm.define "master" do |master|
		master.vm.hostname = "master"
		master.vm.network :private_network, ip: "#{MASTER_IP}"
		master.vm.synced_folder "salt", "/srv/salt/"
		master.vm.provision :shell, inline: $bootstapMaster
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
			ip = i + 3
			minion.vm.hostname = "minion-0#{i}"
			minion.vm.network :private_network, ip: "10.1.1.#{ip}"
			# Set master hostname
			minion.vm.provision :shell, :inline => $bootstrapMinion, :args => [MASTER_IP]
			minion.vm.provision :salt do |salt|
				salt.minion_config = "salt/configs/minion.conf"
				salt.minion_key = "salt/key/minion.pem"
				salt.minion_pub = "salt/key/minion.pub"
				salt.run_highstate = true
			end
		end
	end
  end