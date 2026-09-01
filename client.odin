package main

import "core:fmt"
import "core:os"
import "core:io"
import "core:strings"
import "core:strconv"
import "core:sort"
import "core:text/table"

import vir "project:libvirt"

URL :: "dwt"

decorations :: table.Decorations {
  "┌", "┬", "┐",
  "├", "┼", "┤",
  "└", "┴", "┘",
  "│", "─",
}

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

write_simple_table :: proc(w: io.Writer, tbl: ^table.Table, width_proc: table.Width_Proc = table.unicode_width_proc) {
  table.build(tbl, width_proc)

  width := 0
  for col in 0..<tbl.nr_cols {
    width = width + tbl.colw[col] + tbl.lpad + tbl.rpad
  }

  for row in 0..<tbl.nr_rows {
    for col in 0..<tbl.nr_cols {
      table.write_table_cell(w, tbl, row, col)
    }
    io.write_byte(w, '\n')
    if tbl.has_header_row && row == table.header_row(tbl) {
      table.write_byte_repeat(w, width, '-')
      io.write_byte(w, '\n')
    }
  }
}

write_stream_table :: proc(w: io.Writer, tbl: ^table.Table, width_proc: table.Width_Proc = table.unicode_width_proc) {
  table.build(tbl, width_proc)
  for row in 0..<tbl.nr_rows {
    for col in 0..<tbl.nr_cols {
      cell := table.get_cell(tbl, row, col)
      io.write_string(w, cell.text)
      io.write_byte(w, '\t')
    }
    io.write_byte(w, '\n')
  }
}

id_to_string :: proc(id: i32) -> string {
  if id == -1 do return "-"
  buf := make([]byte, 10)
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

render_table :: proc(tbl: ^table.Table) {
  stdout := table.stdio_writer()
  table.write_decorated_table(stdout, tbl, decorations)
  write_simple_table(stdout, tbl)
  write_stream_table(stdout, tbl)
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
  t := create_domain_table(m)
  render_table(t)
}
