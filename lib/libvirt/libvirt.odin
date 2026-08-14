package libvirt

import "core:c"
import "core:slice"
import "core:log"
import "core:encoding/xml"

foreign import vir "system:libvirt.so.0"

Connect :: struct  { } 

ConnectPtr :: ^Connect

Domain :: struct  { }

DomainPtr :: ^Domain

DomainInfo :: struct {
  state:     u8,           // the running state, one of virDomainState
  maxMem:    c.ulong,      // unsigned long	maxMem	
  memory:    c.ulong,      // the maximum memory in KBytes allowed
  nrVirtCpu: c.ushort,     // unsigned short	nrVirtCpu	the number of virtual CPUs for the domain
  cpuTime:   c.ulonglong   // unsigned long long	cpuTime	the CPU time used in nanoseconds
}

DomainInfoPtr :: ^DomainInfo

DomainFSInfo :: struct {
    mountpoint: cstring,
    name:       cstring,
    fstype:     cstring,
    ndevAlias:  c.size_t,
    devAlias:   [^]cstring,
}

DomainFSInfoPtr :: ^DomainFSInfo

DomainDiskInfo :: struct {
  device: string,
  source: string,
  target: string
}

// --------------------------------------------------------

foreign vir {

  @(link_name="virConnectOpen")
  ConnectOpen :: proc(name: cstring) -> ^Connect ---

  @(link_name="virDomainLookupByName")
  DomainLookupByName :: proc(conn: ^Connect, name: cstring) -> ^Domain ---

  @(link_name="virConnectListAllDomains")
  ConnectListAllDomains ::	proc(conn: ^Connect, domains: ^[^]^Domain, flags: c.uint) -> c.int ---

  @(link_name="virDomainGetName")
  DomainGetName :: proc(domain: ^Domain) -> cstring ---

  @(link_name="virDomainGetXMLDesc")
  DomainGetXMLDesc :: proc(domain: ^Domain, flags: c.uint=0) -> cstring ---

  @(link_name="virDomainGetInfo")
  DomainGetInfo :: proc(domain: ^Domain, info: ^DomainInfo) -> c.int ---

  @(link_name="virDomainGetFSInfo")
  DomainGetFSInfo :: proc(domain: ^Domain, info: ^[^]^DomainFSInfo, flags: c.uint= 0) -> c.int ---

}

find_children :: proc(doc: ^xml.Document, parent: xml.Element_ID, ident: string) -> [dynamic]xml.Element {
  res: [dynamic]xml.Element
  i := 0
  id, found := xml.find_child_by_ident(doc, parent, ident, i) 
  for found {
    append(&res, doc.elements[id]) 
    i += 1
    id, found = xml.find_child_by_ident(doc, parent, ident, i) 
  }
  return res
}

find_attribute :: proc(element: xml.Element, name: string) -> string {
  for attr in element.attribs {
    if attr.key == name do return attr.val
  }
  return ""
}

DomainGetDiskInfo :: proc(domain: ^Domain) -> [dynamic]DomainDiskInfo {
  res: [dynamic]DomainDiskInfo

  text := DomainGetXMLDesc(domain)
  doc, err := xml.parse(string(text))
  devices, devices_ok := xml.find_child_by_ident(doc, 0, "devices") 
  disks := find_children(doc, devices, "disk")
  for disk in disks {
    attr := find_attribute(disk, "type")
    log.info("attr =", attr) 
    attr = find_attribute(disk, "device")
    log.info("attr =", attr) 
  }
  // info[0].device = "disk"
  // info[0].source = "disk.qcow2"
  // info[0].target = "vda"
  return res
}

