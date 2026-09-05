package main

import "core:fmt"
import "core:os"
import "core:io"
import "core:strings"
import "core:strconv"
import "core:sort"
import "core:text/table"

import vir "project:libvirt"

URL := "smol"

// -- main ------------------------------------------------------

ClusterNode :: struct {
  name: string,
  conn: ^vir.Connect
}

Cluster :: []ClusterNode

cluster_init :: proc(config: string) -> Cluster {
  nodes := strings.split(config, " ")
  cluster := make(Cluster, len(nodes))
  for node, i in nodes {
    cluster[i].name = node
    cluster[i].conn = vir.ConnectOpen(node)
  }
  return cluster[:]
}

cluster_list :: proc(cluster: Cluster) -> []vir.DomainDetails {
  res: [dynamic]vir.DomainDetails

  for node in cluster {
    list := vir.list(node.conn)
    append(&res, ..list)
  }
  return res[:]
}

vm :: proc(domain: ^vir.Domain) {
  fsinfo: [^]^vir.DomainFSInfo

  details := vir.domain_get_details(domain)
  
  fmt.printf("\n%s\n", details.name)
  di := vir.DomainGetDiskInfo(domain)
  for d in di {
    fmt.println(d)
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

  domains := vir.list(conn)
  tab := create_domain_table(domains)
  render_table(tab, .Lines)

  vm(domains[0].domain)

  pools := vir.pool_list(conn)
  for pool in pools {
    fmt.printf("\n%v\n", vir.vol_list(pool.pool))
  }

  cluster := cluster_init("dwt smol wee")
  // fmt.println(cluster)
  vms := cluster_list(cluster)
  fmt.println(vms)
}
