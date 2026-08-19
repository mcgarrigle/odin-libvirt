package libvirt

import "core:testing"
import "core:os"
import "core:log"
import "core:encoding/xml"

import vir "project:libvirt"

URL :: "qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1"

// ---------------------------------------------------------------------

@(test)
test_domain :: proc(t: ^testing.T) {
  conn := vir.ConnectOpen(URL)
  domain := vir.DomainLookupByName(conn, "node1")
  di := vir.DomainGetDiskInfo(domain)
  log.info(di)
}
