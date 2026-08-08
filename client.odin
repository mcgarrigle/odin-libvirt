package main

import "core:fmt"
import "core:os"
import "core:strings"

import "project:libvirt"

// -- main ------------------------------------------------------

main :: proc() {

  names: [10]^u8
  domains: [^]libvirt.virDomainPtr

  conn := libvirt.virConnectOpen("qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1")

  // count := libvirt.virConnectListDefinedDomains(conn, &names[0], 10) 

  count := libvirt.virConnectListAllDomains(conn, &domains, 16)

  fmt.printf("domains = %p[%d]\n", domains, count)

  for i in 0..<count {
    name := libvirt.virDomainGetName(domains[i])
    fmt.printf("%p -> %s\n", domains[i], name)
  }
}
