package libvirt

import "core:c"
import "core:slice"
import "core:strings"
import "core:log"
import "core:fmt"
import "core:encoding/xml"

import xp "project:xmlpath"

foreign import vir "system:libvirt.so.0"

Connect :: struct  {} 

Domain :: struct  {}

StoragePool :: struct  {}

StorageVol :: struct  {}

VIR_UUID_BUFLEN :: 16
VIR_UUID_STRING_LEN :: 36
VIR_UUID_STRING_BUFLEN :: 36+1

DomainState :: enum u32 {
  NoState     = 0,  // (0x0) no state
  Running     = 1,  // (0x1) the domain is running
  Blocked     = 2,  // (0x2) the domain is blocked on resource
  Paused      = 3,  // (0x3) the domain is paused by user
  Shutdown    = 4,  // (0x4) the domain is being shut down
  Shutoff     = 5,  // (0x5) the domain is shut off
  Crashed     = 6,  // (0x6) the domain is crashed
  PMSuspended = 7,  // (0x7) the domain is suspended by guest power management
  Last        = 8   // (0x8) NB: this enum value will increase over time as new states are added to the libvirt API. It reflects the last state supported by this version of the libvirt API.
}

DomainCreateFlags :: enum u32 {
  None        = 0,       // Default behavior (Since: 0.0.1)
  Paused      = 1 << 0,  // Launch guest in paused state (Since: 0.8.2)
  Autodestroy = 1 << 1,  // Automatically kill guest when connection is closed (Since: 0.9.3)
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

ConnectListAllStoragePoolsFlags :: enum u32 {
  VIR_CONNECT_LIST_STORAGE_POOLS_INACTIVE      = 1 << 0, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_ACTIVE        = 1 << 1, // (Since: 0.10.2)

  VIR_CONNECT_LIST_STORAGE_POOLS_PERSISTENT    = 1 << 2, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_TRANSIENT     = 1 << 3, // (Since: 0.10.2)

  VIR_CONNECT_LIST_STORAGE_POOLS_AUTOSTART     = 1 << 4, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_NO_AUTOSTART  = 1 << 5, // (Since: 0.10.2)

  VIR_CONNECT_LIST_STORAGE_POOLS_DIR           = 1 << 6, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_FS            = 1 << 7, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_NETFS         = 1 << 8, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_LOGICAL       = 1 << 9, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_DISK          = 1 << 10, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_ISCSI         = 1 << 11, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_SCSI          = 1 << 12, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_MPATH         = 1 << 13, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_RBD           = 1 << 14, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_SHEEPDOG      = 1 << 15, // (Since: 0.10.2)
  VIR_CONNECT_LIST_STORAGE_POOLS_GLUSTER       = 1 << 16, // (Since: 1.2.1)
  VIR_CONNECT_LIST_STORAGE_POOLS_ZFS           = 1 << 17, // (Since: 1.2.8)
  VIR_CONNECT_LIST_STORAGE_POOLS_VSTORAGE      = 1 << 18, // (Since: 3.1.0)
  VIR_CONNECT_LIST_STORAGE_POOLS_ISCSI_DIRECT  = 1 << 19  // (Since: 5.6.0)
}

DomainInfo :: struct {
  state:     DomainState,  // the running state, one of virDomainState
  maxMem:    c.ulong,      // unsigned long maxMem
  memory:    c.ulong,      // the maximum memory in KBytes allowed
  nrVirtCpu: c.ushort,     // the number of virtual CPUs for the domain
  cpuTime:   c.ulonglong   // the CPU time used in nanoseconds
}

DomainDiskInfo :: struct {
  type:   string,
  device: string,
  source: string,
  target: string
}

DomainFSInfo :: struct {
  mountpoint: cstring,
  name:       cstring,
  fstype:     cstring,
  ndevAlias:  c.size_t,
  devAlias:   [^]cstring,
}

StoragePoolInfo :: struct {
  state:      c.int,          // StoragePoolState flags
  capacity:   c.ulonglong,    // Logical size bytes
  allocation: c.ulonglong,    // Current allocation bytes
  available:  c.ulonglong,    // Remaining free space bytes
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
  _DomainGetName :: proc(domain: ^Domain) -> cstring ---

  @(link_name="virDomainGetXMLDesc")
  _DomainGetXMLDesc :: proc(domain: ^Domain, flags: c.uint=0) -> cstring ---

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

  @(link_name="virDomainGetID")
  DomainGetID :: proc(domain: ^Domain) -> c.int ---

  @(link_name="virDomainGetUUID")
  DomainGetUUID :: proc(domain: ^Domain) -> [VIR_UUID_BUFLEN]u8 ---

  @(link_name="virDomainGetUUIDString")
  _DomainGetUUIDString :: proc(domain: ^Domain, uuid: [^]u8) -> c.int ---

  @(link_name="virConnectListAllStoragePools")
  ConnectListAllStoragePools :: proc(conn: ^Connect, pools: ^[^]^StoragePool, flags: c.uint=0) -> c.int ---

  @(link_name="virStoragePoolFree")
  StoragePoolFree :: proc(pool: ^StoragePool) -> c.int ---

  @(link_name="virStoragePoolGetName")
  _StoragePoolGetName :: proc(pool: ^StoragePool) -> cstring ---

  @(link_name="virStoragePoolGetInfo")
  StoragePoolGetInfo :: proc(pool: ^StoragePool, info: ^StoragePoolInfo) -> c.int ---

  @(link_name="virStoragePoolIsActive")
  StoragePoolIsActive :: proc(pool: ^StoragePool) -> c.int ---

  @(link_name="virStoragePoolIsPersistent")
  StoragePoolIsPersistent :: proc(pool: ^StoragePool) -> c.int ---

  @(link_name="virStoragePoolLookupByName")
  StoragePoolLookupByName :: proc(conn: ^Connect, name: cstring) -> ^StoragePool ---

  @(link_name="virStoragePoolLookupByTargetPath")
  StoragePoolLookupByTargetPath :: proc(conn: ^Connect, name: cstring) -> ^StoragePool ---

  @(link_name="virStoragePoolLookupByUUIDString")
  StoragePoolLookupByUUIDString :: proc(conn: ^Connect, name: cstring) -> ^StoragePool ---

  @(link_name="virStorageVolLookupByName")
  StorageVolLookupByName :: proc(pool: ^StoragePool, name: cstring) -> ^StorageVol ---
}

DomainGetUUIDString :: proc(domain: ^Domain) -> string {
  id: [VIR_UUID_STRING_BUFLEN]u8

  err := _DomainGetUUIDString(domain, &id[0])
  builder := strings.builder_make()
  strings.write_bytes(&builder, id[:VIR_UUID_STRING_LEN])
  return strings.to_string(builder)
}

DomainGetName :: proc(domain: ^Domain) -> string {
  return string(_DomainGetName(domain))
}

DomainGetXMLDesc :: proc(domain: ^Domain) -> string {
  return string(_DomainGetXMLDesc(domain))
}

StoragePoolGetName :: proc(pool: ^StoragePool) -> string {
  return string(_StoragePoolGetName(pool))
}

// --------------------------------------------------------

DomainDetails :: struct {
  using info: DomainInfo,
  domain: ^Domain,
  id:   c.int,
  uuid: string,
  name: string
}

StoragePoolDetails :: struct {
  using info: StoragePoolInfo,
  pool: ^StoragePool,
  name:       string,
  active:     c.int,
  persistent: c.int
}

// --------------------------------------------------------

domain_get_details :: proc(domain: ^Domain) -> DomainDetails {
  d: DomainDetails

  _        = DomainGetInfo(domain, &d.info)
  d.domain = domain
  d.id     = DomainGetID(domain)
  d.uuid   = DomainGetUUIDString(domain)
  d.name   = DomainGetName(domain)
  return d
}

list :: proc(conn: ^Connect) -> []DomainDetails {
  domains: [^]^Domain
  res: [dynamic]DomainDetails

  count := ConnectListAllDomains(conn, &domains)
  for i in 0..<count {
    append(&res, domain_get_details(domains[i]))
  }
  return res[:]
}

pool_get_details :: proc(pool: ^StoragePool) -> StoragePoolDetails {
  p: StoragePoolDetails

  _ = StoragePoolGetInfo(pool, &p.info)
  p.pool       = pool
  p.name       = StoragePoolGetName(pool)
  p.active     = StoragePoolIsActive(pool)
  p.persistent = StoragePoolIsPersistent(pool)
  return p
}

pool_list :: proc(conn: ^Connect) -> []StoragePoolDetails {
  pools: [^]^StoragePool
  res: [dynamic]StoragePoolDetails

  count := ConnectListAllStoragePools(conn, &pools)
  for i in 0..<count {
    append(&res, pool_get_details(pools[i]))
  }
  return res[:]
}

DomainGetDiskInfo :: proc(domain: ^Domain) -> []DomainDiskInfo {
  res: [dynamic]DomainDiskInfo

  text := DomainGetXMLDesc(domain)
  doc, err := xml.parse(text)
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
