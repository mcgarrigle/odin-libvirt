package libvirt

import "core:c"

foreign import lv "libvirt.so.0"

virConnect :: struct  { } 

virConnectPtr :: ^virConnect

virDomain :: struct  { }

virDomainPtr :: ^virDomain


// typedef virConnect * virConnectPtr;

// virConnectPtr	virConnectOpen		(const char * name)

foreign lv {

  virConnectOpen :: proc(name: cstring) -> virConnectPtr ---

  // int	virConnectListAllDomains	(virConnectPtr conn, virDomainPtr ** domains, unsigned int flags)

  virConnectListAllDomains ::	proc(conn: virConnectPtr, domains: ^[^]virDomainPtr, flags: c.uint) -> c.int ---

  // int	virConnectListDefinedDomains	(virConnectPtr conn, char ** const names, int maxnames)

  virConnectListDefinedDomains ::	proc(conn: virConnectPtr, names: [^]^u8, maxnames: c.int) -> c.int ---

  // const char *	virDomainGetName	(virDomainPtr domain)

  virDomainGetName :: proc(domain: virDomainPtr) -> cstring ---

}
