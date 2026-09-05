package libvirt

import "core:testing"
import "core:os"
import "core:log"
import "core:encoding/xml"

import vir "project:libvirt"

URL :: "smol"

// ---------------------------------------------------------------------

conn: ^Connect
domain: ^Domain

setup :: proc() {
  conn   := vir.ConnectOpen("smol")
  domain := vir.DomainLookupByName(conn, "node1")
}

@(test)
test_domain_get_info :: proc(t: ^testing.T) {
  di: DomainInfo

  vir.DomainGetInfo(domain, &di)
  log.info(di)
}

@(test)
test_domain_get_disk_info :: proc(t: ^testing.T) {
  di := vir.DomainGetDiskInfo(domain)
  log.info(di)
}

@(test)
test_domain_get_state :: proc(t: ^testing.T) {
  state: DomainState
  reason: i32

  _ = vir.DomainGetState(domain, &state, reason=&reason)
  log.info(state, reason)
}

@(test)
test_pools_list :: proc(t: ^testing.T) {
  di := vir.DomainGetDiskInfo(domain)
  log.info(di)
}
