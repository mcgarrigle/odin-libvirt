package libvirt

import "core:c"
import "core:slice"
import "core:strings"
import "core:log"
import "core:fmt"
import "core:encoding/xml"

// --------------------------------------------------------

DomainDetails :: struct {
  using info: DomainInfo,
  domain: ^Domain,
  host: string,
  id:   c.int,
  uuid: string,
  name: string,
  autostart: i32,
  autostart_once: i32
}

domain_get_details :: proc(domain: ^Domain) -> DomainDetails {
  d: DomainDetails

  _        = DomainGetInfo(domain, &d.info)
  d.domain = domain
  d.id     = DomainGetID(domain)
  d.uuid   = DomainGetUUIDString(domain)
  d.name   = DomainGetName(domain)
  _ = DomainGetAutostart(domain, &d.autostart)
  _ = DomainGetAutostartOnce(domain, &d.autostart_once)
  return d
}

list :: proc(conn: ^Connect, host: string = "") -> []DomainDetails {
  domains: [^]^Domain
  res: [dynamic]DomainDetails

  count := ConnectListAllDomains(conn, &domains)
  for i in 0..<count {
    dom := domain_get_details(domains[i])
    dom.host = host
    append(&res, dom)
  }
  return res[:]
}

// --------------------------------------------------------

StoragePoolDetails :: struct {
  using info: StoragePoolInfo,
  pool: ^StoragePool,
  host:       string,
  name:       string,
  active:     c.int,
  persistent: c.int
}

pool_get_details :: proc(pool: ^StoragePool) -> StoragePoolDetails {
  p: StoragePoolDetails

  _            = StoragePoolGetInfo(pool, &p.info)
  p.pool       = pool
  p.name       = StoragePoolGetName(pool)
  p.active     = StoragePoolIsActive(pool)
  p.persistent = StoragePoolIsPersistent(pool)
  return p
}

pool_list :: proc(conn: ^Connect, host: string = "") -> []StoragePoolDetails {
  pools: [^]^StoragePool
  res: [dynamic]StoragePoolDetails

  count := ConnectListAllStoragePools(conn, &pools)
  for i in 0..<count {
    p := pool_get_details(pools[i])
    p.host = host
    append(&res, p)
  }
  return res[:]
}

// --------------------------------------------------------

StorageVolDetails :: struct {
  using info: StorageVolInfo,
  vol:  ^StorageVol,
  host: string,
  pool: string,
  key:  string,
  name: string,
  path: string
}

vol_get_details :: proc(vol: ^StorageVol) -> StorageVolDetails {
  v: StorageVolDetails

  _      = StorageVolGetInfo(vol, &v.info)
  v.vol  = vol
  v.key  = StorageVolGetKey(vol)
  v.name = StorageVolGetName(vol)
  v.path = StorageVolGetPath(vol)
  return v
}

vol_list :: proc(pool: ^StoragePool, host: string = "", pool_name: string = "") -> []StorageVolDetails {
  vols: [^]^StorageVol
  res: [dynamic]StorageVolDetails

  count := StoragePoolListAllVolumes(pool, &vols)
  for i in 0..<count {
    v := vol_get_details(vols[i])
    v.host = host
    v.pool = pool_name
    append(&res, v)
  }
  return res[:]
}
