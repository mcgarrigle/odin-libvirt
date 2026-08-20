package libvirt

import "core:c"
import "core:slice"
import "core:log"
import "core:encoding/xml"

import xp "project:xmlpath"

foreign import vir "system:libvirt.so.0"

Connect :: struct  {} 

ConnectPtr :: ^Connect

Domain :: struct  {}

DomainPtr :: ^Domain

DomainState :: enum u32 {
  NoState     =	0,  // (0x0)	no state
  Running     =	1,  // (0x1)	the domain is running
  Blocked     =	2,  // (0x2)	the domain is blocked on resource
  Paused      =	3,  // (0x3)	the domain is paused by user
  Shutdown    =	4,  // (0x4)	the domain is being shut down
  Shutoff     =	5,  // (0x5)	the domain is shut off
  Crashed     =	6,  // (0x6)	the domain is crashed
  PMSuspended =	7,  // (0x7)	the domain is suspended by guest power management
  Last        =	8   // (0x8)	NB: this enum value will increase over time as new states are added to the libvirt API. It reflects the last state supported by this version of the libvirt API.
}

DomainCreateFlags :: enum u32 {
  None        = 0,       // Default behavior (Since: 0.0.1)
  Paused      = 1 << 0,  // Launch guest in paused state (Since: 0.8.2)
  Autodestroy = 1 << 1,  // Automatically kill guest when virConnectPtr is closed (Since: 0.9.3)
  BypassCache = 1 << 2,  // Avoid file system cache pollution (Since: 0.9.4)
  ForceBoot   = 1 << 3,  // Boot, discarding any managed save (Since: 0.9.5)
  Validate    = 1 << 4,  // Validate the XML document against schema (Since: 1.2.12)
  ResetNVRAM  = 1 << 5   // Re-initialize NVRAM/varstore from template (Since: 8.1.0)
} 

ConnectListAllDomainsFlags :: enum u32 {
  All           = 0,
  Active        = 1 << 0, // (Since: 0.9.13)
  Inactive      = 1 << 1, // (Since: 0.9.13)

  Persistent    = 1 << 2, // (Since: 0.9.13)
  Transient     = 1 << 3, // (Since: 0.9.13)

  Running       = 1 << 4, // (Since: 0.9.13)
  Paused        = 1 << 5, // (Since: 0.9.13)
  Shutoff       = 1 << 6, // (Since: 0.9.13)
  Other         = 1 << 7, // (Since: 0.9.13)

  ManagedSave   = 1 << 8, // (Since: 0.9.13)
  NoManagedSave = 1 << 9, // (Since: 0.9.13)

  AutoStart     = 1 << 10, // (Since: 0.9.13)
  NoAutoStart   = 1 << 11, // (Since: 0.9.13)

  HasSnapshot   = 1 << 12, // (Since: 0.9.13)
  NoSnapshot    = 1 << 13, // (Since: 0.9.13)

  HasCheckpoint = 1 << 14, // (Since: 5.6.0)
  NoCheckpoint  = 1 << 15  // (Since: 5.6.0)
}

DomainDestroyFlagValues :: enum u32 {
  Default    = 0,       // Default behavior - could lead to data loss!! (Since: 0.9.10)
  Graceful   = 1 << 0,  // only SIGTERM, no SIGKILL (Since: 0.9.10)
  RemoveLogs = 1 << 1,  // remove VM logs on destroy (Since: 8.3.0)
}

DomainInfo :: struct {
  state:     DomainState,  // the running state, one of virDomainState
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
  type:   string,
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
  ConnectListAllDomains :: proc(conn: ^Connect, domains: ^[^]^Domain, flags: ConnectListAllDomainsFlags=.All) -> c.int ---

  @(link_name="virDomainGetName")
  DomainGetName :: proc(domain: ^Domain) -> cstring ---

  @(link_name="virDomainGetXMLDesc")
  DomainGetXMLDesc :: proc(domain: ^Domain, flags: c.uint=0) -> cstring ---

  @(link_name="virDomainGetInfo")
  DomainGetInfo :: proc(domain: ^Domain, info: ^DomainInfo) -> c.int ---

  @(link_name="virDomainGetFSInfo")
  DomainGetFSInfo :: proc(domain: ^Domain, info: ^[^]^DomainFSInfo, flags: c.uint=0) -> c.int ---

  @(link_name="virDomainGetState")
  DomainGetState :: proc(domain: ^Domain, state: ^DomainState, reason: ^c.int, flags: c.uint=0) -> c.int ---

  @(link_name="virDomainCreateWithFlags")
  DomainCreateWithFlags :: proc(domain: ^Domain, flags: DomainCreateFlags=.None) -> c.int ---

  @(link_name="virDomainDestroy")
  DomainDestroy :: proc(domain: Domain) -> c.int ---

  @(link_name="virDomainDestroyFlags")
  DomainDestroyFlags :: proc(domain: Domain, flags: DomainDestroyFlagValues) -> c.int ---

}

// --------------------------------------------------------

DomainGetDiskInfo :: proc(domain: ^Domain) -> []DomainDiskInfo {
  res: [dynamic]DomainDiskInfo

  text := DomainGetXMLDesc(domain)
  doc, err := xml.parse(string(text))
  disks := xp.select_elements(doc, xp.root, "devices/disk")
  for disk, i in disks {
    info: DomainDiskInfo
    info.type   = xp.attribute(doc, disk, "type")
    info.device = xp.attribute(doc, disk, "device")
    info.source = xp.select_attribute(doc, disk, "source", "file")
    info.target = xp.select_attribute(doc, disk, "target", "dev")
    append(&res, info)
  }
  return res[:]
}
