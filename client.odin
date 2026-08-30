package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:sort"
import "core:text/table"

import vir "project:libvirt"

URL :: "dwt"

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

compare_domains :: proc(a, b: vir.DomainDetails) -> int {
  return sort.compare_strings(a.name, b.name)
}

domain_table :: proc(domains: []vir.DomainDetails) {
  sort.heap_sort_proc(domains, compare_domains)

  stdout := table.stdio_writer()
  tbl := table.init(&table.Table{})
  defer table.destroy(tbl)

  table.padding(tbl, 1, 1)
  table.header(tbl, "UUID", "Name", "State")
  for domain in domains {
    table.row(tbl, domain.uuid, domain.name, domain.state)
  }

  decorations := table.Decorations {
    "┌", "┬", "┐",
    "├", "┼", "┤",
    "└", "┴", "┘",
    "│", "─",
  }

  table.write_decorated_table(stdout, tbl, decorations)

}

main :: proc() {
  domains: [^]^vir.Domain

  conn := vir.ConnectOpen(URL)
  // count := vir.ConnectListAllDomains(conn, &domains)

  // fmt.printf("%p => domains[%d]\n", domains, count)

  // for i in 0..<count {
  //   vm(domains[i])
  // }

  m := vir.list(conn)
  domain_table(m)
}
