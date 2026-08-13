package libvirt

import "core:testing"
import "core:os"
import "core:log"
import "core:encoding/xml"

import "project:libvirt"

// ---------------------------------------------------------------------

find_children :: proc(doc: ^xml.Document, parent: xml.Element_ID, ident: string) -> [dynamic]xml.Element {
  res : [dynamic]xml.Element
  i := 0
  id, found := xml.find_child_by_ident(doc, parent, ident, i) 
  for found {
    append(&res, doc.elements[id]) 
    i = i + 1
    id, found = xml.find_child_by_ident(doc, parent, ident, i) 
  }
  return res
}

@(test)
test_parse_domain_xml :: proc(t: ^testing.T) {
  text, _ := os.read_entire_file("node1.xml", context.allocator)
  doc, err := xml.parse(text)
  devices, devices_ok := xml.find_child_by_ident(doc, 0, "devices") 
  log.info(doc.elements[devices])
  disks := find_children(doc, devices, "disk")
  log.info(disks)
/*  i := 0
  disk, disk_ok := xml.find_child_by_ident(doc, devices, "disk", i) 
  for disk_ok {
    log.info(i, disk_ok, doc.elements[disk])
    // log.info(doc.elements[disk])
    i = i + 1
    if i == 5 do break
    disk, disk_ok = xml.find_child_by_ident(doc, devices, "disk", i) 
  }
  */
}
