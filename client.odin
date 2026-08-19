package main

import "core:fmt"
import "core:os"
import "core:strings"

import vir "project:libvirt"

URL :: "qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1"

// -- main ------------------------------------------------------

vm :: proc(domain: ^vir.Domain) {
  dminfo: vir.DomainInfo
  fsinfo: [^]^vir.DomainFSInfo

  name := vir.DomainGetName(domain)
  _ = vir.DomainGetInfo(domain, &dminfo)
  n := vir.DomainGetFSInfo(domain, &fsinfo)
  fmt.printf("\n%p => %s\n%v\n", domain, name, dminfo)
  for j in 0..<n {
    fmt.printf("%v\n", fsinfo[j]^)
    for k in 0..<fsinfo[j].ndevAlias {
      fmt.printf("  alias = %s\n", fsinfo[j].devAlias[k])
    }
  }
}

main :: proc() {
  domains: [^]^vir.Domain

  conn := vir.ConnectOpen(URL)
  count := vir.ConnectListAllDomains(conn, &domains)

  fmt.printf("%p => domains[%d]\n", domains, count)

  for i in 0..<count {
    vm(domains[i])
  }

}
