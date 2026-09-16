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

vm :: proc(domain: ^vir.Domain) {
  fsinfo: [^]^vir.DomainFSInfo

  details := vir.domain_get_details(domain)
  
  fmt.printf("\n%s\n", details.name)
  di := vir.DomainGetDiskInfo(domain)
  for d in di {
    fmt.println(d)
  }
}

format_enabled :: proc(state: i32) -> string {
  if state == 0 do return "disabled"
  return "enabled"
}

format_bytes :: proc(bytes: u64) -> string {
	units := []string{
		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB",
	}

	value := f64(bytes)
	unit := 0

	for value >= 1024.0 && unit < len(units)-1 {
		value /= 1024.0
		unit += 1
	}

	return fmt.aprintf("%.2f %s", value, units[unit])
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

create_domain_list_table :: proc(domains: []vir.DomainDetails) -> ^table.Table {
  sort.heap_sort_proc(domains, compare_domains)

  tbl := table.init(new(table.Table), context.allocator)
  table.header(tbl, "ID", "Name", "State", "Host")
  for domain in domains {
    table.row(tbl, id_to_string(domain.id), domain.name, domain.state, domain.host)
  }
  return tbl
}

create_domain_table :: proc(domain: vir.DomainDetails) -> ^table.Table {
  tbl := table.init(new(table.Table), context.allocator)
  table.row(tbl, "Name:", domain.name)
  table.row(tbl, "State:", domain.state)
  table.row(tbl, "CPUs:", domain.nrVirtCpu)
  table.row(tbl, "Memory:", format_bytes(domain.memory * 1024))
  table.row(tbl, "Autostart:", format_enabled(domain.autostart))
  table.row(tbl, "AutostartOnce:", format_enabled(domain.autostart_once))
  return tbl
}


error_handler :: proc "cdecl" (data: rawptr, err: ^vir.Error) {
  // context := runtime.default_context()
  // fmt.println("ERR:", err)
  // os.write_string(os.stdout, "err")
}

main :: proc() {

  // conn := vir.ConnectOpen(URL)
  // domains := vir.list(conn)

  names := []string{"dwt", "smol", "wee"}
  cluster := cluster_init(names)
  // vir.ConnSetErrorFunc(cluster[0].conn, nil, error_handler)
  // vir.ConnSetErrorFunc(cluster[1].conn, nil, error_handler)
  // vir.ConnSetErrorFunc(cluster[2].conn, nil, error_handler)

  domains := cluster_list(cluster)
  // tab := create_domain_list_table(domains)
  // render_table(tab, .Lines)

  dom, ok := cluster_find_domain(domains, "sdev")
  // if ok do fmt.println(dom)
  tab := create_domain_table(dom)
  render_table(tab, .Simple)
}
