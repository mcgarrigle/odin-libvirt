package main

import "core:fmt"
import "core:os"
import "core:strings"

import "project:libvirt"

// -- main ------------------------------------------------------

vm :: proc(domain: libvirt.virDomainPtr) {
  info: libvirt.virDomainInfo
  fsinfo: [^]libvirt.virDomainFSInfoPtr

  name := libvirt.virDomainGetName(domain)
  _ = libvirt.virDomainGetInfo(domain, &info)
  n := libvirt.virDomainGetFSInfo(domain, &fsinfo)
  fmt.printf("%p => %s\n%v\n", domain, name, info)
  for j in 0..<n {
    fmt.printf("%v\n", fsinfo[j].name, fsinfo[j])
    for k in 0..<fsinfo[j].ndevAlias {
      fmt.printf("\n  alias = %s\n", fsinfo[j].devAlias[k])
    }
  }
}

main :: proc() {
  domains: [^]libvirt.virDomainPtr

  conn := libvirt.virConnectOpen("qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1")

  count := libvirt.virConnectListAllDomains(conn, &domains, 16)

  fmt.printf("%p => domains[%d]\n", domains, count)

  // for i in 0..<count {
  //   vm(domains[i])
  // }

  domain := libvirt.virDomainLookupByName(conn, "node1")
  vm(domain)
}
