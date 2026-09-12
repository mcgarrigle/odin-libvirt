package libvirt

import "core:testing"
import "core:os"
import "core:log"
import "core:encoding/xml"

import vir "project:libvirt"

URL :: "smol"

// ---------------------------------------------------------------------

setup :: proc() -> ^Domain {
  conn   := vir.ConnectOpen("smol")
  return vir.DomainLookupByName(conn, "node1")
}

@(test)
test_domain_get_info :: proc(t: ^testing.T) {
  domain := setup()
  di: DomainInfo

  vir.DomainGetInfo(domain, &di)
  log.info(di)
}

@(test)
test_domain_get_disk_info :: proc(t: ^testing.T) {
  domain := setup()
  di := vir.DomainGetDiskInfo(domain)
  log.info(di)
}

@(test)
test_domain_get_state :: proc(t: ^testing.T) {
  domain := setup()
  state: DomainState
  reason: i32

  _ = vir.DomainGetState(domain, &state, reason=&reason)
  log.info(state, reason)
}

@(test)
test_pools_list :: proc(t: ^testing.T) {
  domain := setup()
  di := vir.DomainGetDiskInfo(domain)
  log.info(di)
}
