package main

import "core:fmt"
import "core:os"
import "core:strings"

import "project:libvirt"

URL :: "qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1"

// -- main ------------------------------------------------------

vm :: proc(domain: ^libvirt.Domain) {
  dminfo: libvirt.DomainInfo
  fsinfo: [^]^libvirt.DomainFSInfo

  name := libvirt.DomainGetName(domain)
  _ = libvirt.DomainGetInfo(domain, &dminfo)
  n := libvirt.DomainGetFSInfo(domain, &fsinfo)
  fmt.printf("%p => %s\n%v\n", domain, name, dminfo)
  for j in 0..<n {
    fmt.printf("%v\n", fsinfo[j]^)
    for k in 0..<fsinfo[j].ndevAlias {
      fmt.printf("  alias = %s\n", fsinfo[j].devAlias[k])
    }
  }
}

main :: proc() {
  domains: [^]^libvirt.Domain

  conn := libvirt.ConnectOpen(URL)

  count := libvirt.ConnectListAllDomains(conn, &domains, 16)

  fmt.printf("%p => domains[%d]\n", domains, count)

  // for i in 0..<count {
  //   vm(domains[i])
  // }

  domain := libvirt.DomainLookupByName(conn, "node1")
  vm(domain)
}
