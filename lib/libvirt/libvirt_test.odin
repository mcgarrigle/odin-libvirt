package libvirt

import "core:testing"
import "core:os"
import "core:log"
import "core:encoding/xml"

import vir "project:libvirt"

URL :: "qemu+ssh://pete@dwt.mac.wales/system?keyfile=/home/pete/.ssh/swarm_ed25519&no_verify=1"

// ---------------------------------------------------------------------

fixture_xml_doc :: proc() -> ^xml.Document {
  text, _ := os.read_entire_file("node1.xml", context.allocator)
  doc, err := xml.parse(text)
  return doc
}

@(test)
test_parse_domain_xml :: proc(t: ^testing.T) {
  doc := fixture_xml_doc()
  devices, devices_ok := xml.find_child_by_ident(doc, 0, "devices") 
  // log.info(doc.elements[devices])
  disks := find_children(doc, devices, "disk")
  // log.info(disks)
}

@(test)
test_domain :: proc(t: ^testing.T) {
  conn := vir.ConnectOpen(URL)
  domain := vir.DomainLookupByName(conn, "node1")
  di := vir.DomainGetDiskInfo(domain)
  // log.info(di)
}
