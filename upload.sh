#!/bin/sh -xe
packer build packer.json
gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp packer__vmware-iso.ova gs://s.k2i.ooo/rancheros-idcfcloud.ova
gsutil acl set public-read gs://s.k2i.ooo/rancheros-idcfcloud.ova
sleep 60
cloudstack-api registerTemplate --name "RancherOS 0.7.1(k-macos) $(date +%FT%T)" --displaytext RancherOS --format OVA --hypervisor VMWare --ostypeid a9707ed7-9a71-11e6-83f7-1e00d4000471 --passwordenabled false --zoneid 95c8746d-57b3-421f-9375-34bea93e2a3d --url http://s.k2i.ooo/rancheros-idcfcloud.ova
