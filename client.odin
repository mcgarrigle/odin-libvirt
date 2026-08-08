package main

import "core:fmt"
import "core:os"
import "core:strings"

import "project:libvirt"

// -- main ------------------------------------------------------

main :: proc() {

  names: [10]^u8
  domains: [^]libvirt.virDomainPtr
  info: libvirt.virDomainInfo
  fsinfo: [^]libvirt.virDomainFSInfoPtr

  conn := libvirt.virConnectOpen("qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1")

  // count := libvirt.virConnectListDefinedDomains(conn, &names[0], 10) 

  count := libvirt.virConnectListAllDomains(conn, &domains, 16)

  fmt.printf("domains = %p[%d]\n", domains, count)

  for i in 0..<count {
    name := libvirt.virDomainGetName(domains[i])
    _ = libvirt.virDomainGetInfo(domains[i], &info)
    n := libvirt.virDomainGetFSInfo(domains[i], &fsinfo)
    fmt.printf("%p -> %s %v\n", domains[i], name, info)
    for j in 0..<n {
      fmt.printf("%v\n", fsinfo[j].name, fsinfo[j])
      for k in 0..<fsinfo[j].ndevAlias {
        fmt.printf("  alias = %s\n", fsinfo[j].devAlias[k])
      }
    }
  }
}
