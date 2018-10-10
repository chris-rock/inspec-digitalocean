droplet = attribute('digitalocean_droplet.web')
cert = attribute('digitalocean_certificate.web')
ssh = attribute('digitalocean_ssh_key.key')
volume = attribute('digitalocean_volume.web')
loadbalancer = attribute('digitalocean_loadbalancer.public')

describe digitalocean_ssh_key(name: ssh['name']) do
  it { should exist }
  its('id') { should cmp ssh['id'] }
  its('name') { should eq 'Terraform Example' }
  its('fingerprint') { should eq ssh['fingerprint'] }
  its('public_key') { should_not eq '' }
end

describe digitalocean_ssh_key(id: ssh['id'].to_i) do
  it { should exist }
  its('name') { should eq 'Terraform Example' }
  its('fingerprint') { should eq ssh['fingerprint'] }
  its('public_key') { should_not eq '' }
end

describe digitalocean_droplet(id: droplet['id']) do
  it { should exist }
  its('name') { should eq 'nginx-web-ams3' }
  # its('ssh_keys') { should eq []}
  its('image') { should eq 'ubuntu-16-04-x64' }
  its('region') { should eq 'ams3' }
  its('size') { should eq 's-1vcpu-1gb' }
end

describe digitalocean_volume(id: volume['id']) do
  it { should exist }
  its('name') { should eq 'nginx html content' }
  its('description') { should eq 'web volume' }
  its('droplet_ids') { should include droplet['id'].to_i }
  its('size') { should eq 100 }
end

describe digitalocean_tag(name: 'nginx') do
  it { should exist }
end

describe digitalocean_loadbalancer(name: 'loadbalancer-1') do
  it { should exist }
  its('name') { should eq 'loadbalancer-1' }
  its('status') { should eq 'active' }
  its('algorithm') { should eq 'round_robin' }
  its('ip') { should eq loadbalancer['ip'] }
end

describe digitalocean_certificate(id: cert['id']) do
  it { should exist }
  its('name') { should eq 'nginx' }
  its('type') { should eq 'custom' }
  its('state') { should eq 'verified' }
  its('sha1_fingerprint') { should eq 'd628736d059eab8911c7891d22e1faa50216acc8' }
  its('not_after') { should eq '2019-10-09T21:29:54Z' }
end
