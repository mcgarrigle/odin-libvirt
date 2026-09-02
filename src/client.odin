package main

import "core:fmt"
import "core:os"
import "core:io"
import "core:strings"
import "core:strconv"
import "core:sort"
import "core:text/table"

import vir "project:libvirt"

URL :: "smol"

// -- main ------------------------------------------------------

vm :: proc(domain: ^vir.Domain) {
  dminfo: vir.DomainInfo
  fsinfo: [^]^vir.DomainFSInfo

  name := vir.DomainGetName(domain)
  _ = vir.DomainGetInfo(domain, &dminfo)
  fmt.printf("\n%p => %s\n%v\n", domain, name, dminfo)
  di := vir.DomainGetDiskInfo(domain)
  for d in di {
    fmt.println(d)
  }
  n := vir.DomainGetFSInfo(domain, &fsinfo)
  for j in 0..<n {
    fmt.printf("%v\n", fsinfo[j]^)
    for k in 0..<fsinfo[j].ndevAlias {
      fmt.printf("  alias = %s\n", fsinfo[j].devAlias[k])
    }
  }
}

id_to_string :: proc(id: i32) -> string {
  buf := make([]byte, 10)
  buf[0] = '-'
  if id == -1 do return string(buf)
  return strconv.write_int(buf[:], i64(id), 10)
}

compare_domains :: proc(a, b: vir.DomainDetails) -> int {
  return sort.compare_strings(a.name, b.name)
}

create_domain_table :: proc(domains: []vir.DomainDetails) -> ^table.Table {
  sort.heap_sort_proc(domains, compare_domains)

  tbl := table.init(new(table.Table), context.allocator)
  table.padding(tbl, 1, 1)
  table.header(tbl, "ID", "Name", "State")
  for domain in domains {
    table.row(tbl, id_to_string(domain.id), domain.name, domain.state)
  }
  return tbl
}

main :: proc() {
  // domains: [^]^vir.Domain

  // count := vir.ConnectListAllDomains(conn, &domains)

  // fmt.printf("%p => domains[%d]\n", domains, count)

  // for i in 0..<count {
  //   vm(domains[i])
  // }

  conn := vir.ConnectOpen(URL)

  pools: [^]^vir.StoragePool
  count := vir.ConnectListAllStoragePools(conn, &pools)
  fmt.printf("%p => pools[%d]\n", pools, count)
  for i in 0..<count {
    fmt.printf("%s\n", string(vir._StoragePoolGetName(pools[i])))
  }

  domains := vir.list(conn)
  tab := create_domain_table(domains)
  render_table(tab, .Lines)
}
