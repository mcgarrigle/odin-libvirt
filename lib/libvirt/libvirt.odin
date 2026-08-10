package libvirt

import "core:c"

foreign import lv "system:libvirt.so.0"

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

// --------------------------------------------------------

foreign lv {

  @(link_name="virConnectOpen")
  ConnectOpen :: proc(name: cstring) -> ^Connect ---

  @(link_name="virDomainLookupByName")
  DomainLookupByName :: proc(conn: ^Connect, name: cstring) -> ^Domain ---

  @(link_name="virConnectListAllDomains")
  ConnectListAllDomains ::	proc(conn: ^Connect, domains: ^[^]^Domain, flags: c.uint) -> c.int ---

  @(link_name="virDomainGetName")
  DomainGetName :: proc(domain: ^Domain) -> cstring ---

  @(link_name="virDomainGetInfo")
  DomainGetInfo :: proc(domain: ^Domain, info: ^DomainInfo) -> c.int ---

  @(link_name="virDomainGetFSInfo")
  DomainGetFSInfo :: proc(domain: ^Domain, info: ^[^]^DomainFSInfo, flags: c.uint = 0) -> c.int ---

}
