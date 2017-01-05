#!/bin/sh -xe
version="0.7.1"
[ ! -f packer__vmware-iso.ova ] || rmtrash packer__vmware-iso.ova
[ -f rancheros.iso ] || curl -o rancheros.iso "https://releases.rancher.com/os/v${version}/rancheros.iso"
# export ISO_MD5="$(curl -s https://releases.rancher.com/os/v${version}/iso-checksums.txt | awk '/^md5/{print $2}')"
packer build packer.json
gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp packer__vmware-iso.ova gs://s.k2i.ooo/rancheros-idcfcloud.ova
gsutil acl set public-read gs://s.k2i.ooo/rancheros-idcfcloud.ova
sleep 60
date="$(date +%FT%T)"
# cloudstack-api registerTemplate --name "RancherOS ${version} ${date}" --displaytext RancherOS --format OVA --hypervisor VMWare --ostypeid c20faebd-4ada-11e4-bd06-005056812ba5 --passwordenabled false --zoneid 01738d49-2722-4788-891e-848536663c6e --url http://s.k2i.ooo/rancheros-idcfcloud.ova
CLOUDSTACK_ENDPOINT="https://compute.jp-east.idcfcloud.com/client/api" cs --region jp-east registerTemplate name="RancherOS ${version} ${date}" displaytext=RancherOS format=OVA hypervisor=VMWare ostypeid="c20faebd-4ada-11e4-bd06-005056812ba5" passwordenabled=false zoneid="01738d49-2722-4788-891e-848536663c6e" url="http://s.k2i.ooo/rancheros-idcfcloud.ova"
# cloudstack-api registerTemplate --name "RancherOS ${version} ${date}" --displaytext RancherOS --format OVA --hypervisor VMWare --ostypeid a9707ed7-9a71-11e6-83f7-1e00d4000471 --passwordenabled false --zoneid 95c8746d-57b3-421f-9375-34bea93e2a3d --url http://s.k2i.ooo/rancheros-idcfcloud.ova
CLOUDSTACK_ENDPOINT="https://compute.jp-east-2.idcfcloud.com/client/api" cs --region jp-east-2 registerTemplate name="RancherOS ${version} ${date}" displaytext=RancherOS format=OVA hypervisor=VMWare ostypeid="a9707ed7-9a71-11e6-83f7-1e00d4000471" passwordenabled=false zoneid="95c8746d-57b3-421f-9375-34bea93e2a3d" url="http://s.k2i.ooo/rancheros-idcfcloud.ova"
