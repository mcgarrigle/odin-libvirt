package libvirt

import "core:c"

foreign import lv "system:libvirt.so.0"

virConnect :: struct  { } 

virConnectPtr :: ^virConnect

virDomain :: struct  { }

virDomainPtr :: ^virDomain

virDomainInfo :: struct {
  state:     u8,           // the running state, one of virDomainState
  maxMem:    c.ulong,      // unsigned long	maxMem	
  memory:    c.ulong,      // the maximum memory in KBytes allowed
  nrVirtCpu: c.ushort,     // unsigned short	nrVirtCpu	the number of virtual CPUs for the domain
  cpuTime:   c.ulonglong   // unsigned long long	cpuTime	the CPU time used in nanoseconds
}

virDomainInfoPtr :: ^virDomainInfo

virDomainFSInfo :: struct {
    mountpoint: cstring,
    name:       cstring,
    fstype:     cstring,
    ndevAlias:  c.size_t,
    devAlias:   [^]cstring,
}

virDomainFSInfoPtr :: ^virDomainFSInfo

// --------------------------------------------------------

foreign lv {

  virConnectOpen :: proc(name: cstring) -> virConnectPtr ---

  virConnectListAllDomains ::	proc(conn: virConnectPtr, domains: ^[^]virDomainPtr, flags: c.uint) -> c.int ---

  virConnectListDefinedDomains ::	proc(conn: virConnectPtr, names: [^]^u8, maxnames: c.int) -> c.int ---

  virDomainGetName :: proc(domain: virDomainPtr) -> cstring ---

  virDomainGetInfo :: proc(domain: virDomainPtr, info: virDomainInfoPtr) -> c.int ---

  virDomainGetFSInfo :: proc(domain: virDomainPtr, info: ^[^]virDomainFSInfoPtr, flags: c.uint = 0) -> c.int ---

}
