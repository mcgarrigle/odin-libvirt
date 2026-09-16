package libvirt

import "core:c"

foreign import vir "system:libvirt.so.0"


ErrorDomain :: enum u32 {
  FROM_NONE              = 0,
  FROM_XEN               = 1,  // Error at Xen hypervisor layer
  FROM_XEND              = 2,  // Error at connection with xend daemon
  FROM_XENSTORE          = 3,  // Error at connection with xen store
  FROM_SEXPR             = 4,  // Error in the S-Expression code
  FROM_XML               = 5,  // Error in the XML code
  FROM_DOM               = 6,  // Error when operating on a domain
  FROM_RPC               = 7,  // Error in the XML-RPC code
  FROM_PROXY             = 8,  // Error in the proxy code; unused since 0.8.6
  FROM_CONF              = 9,  // Error in the configuration file handling
  FROM_QEMU              = 10, // Error at the QEMU daemon
  FROM_NET               = 11, // Error when operating on a network
  FROM_TEST              = 12, // Error from test driver
  FROM_REMOTE            = 13, // Error from remote driver
  FROM_OPENVZ            = 14, // Error from OpenVZ driver
  FROM_XENXM             = 15, // Error at Xen XM layer
  FROM_STATS_LINUX       = 16, // Error in the Linux Stats code
  FROM_LXC               = 17, // Error from Linux Container driver
  FROM_STORAGE           = 18, // Error from storage driver
  FROM_NETWORK           = 19, // Error from network config
  FROM_DOMAIN            = 20, // Error from domain config
  FROM_UML               = 21, // Error at the UML driver; unused since 5.0.0
  FROM_NODEDEV           = 22, // Error from node device monitor
  FROM_XEN_INOTIFY       = 23, // Error from xen inotify layer
  FROM_SECURITY          = 24, // Error from security framework
  FROM_VBOX              = 25, // Error from VirtualBox driver
  FROM_INTERFACE         = 26, // Error when operating on an interface
  FROM_ONE               = 27, // The OpenNebula driver no longer exists. Retained for ABI/API compat only
  FROM_ESX               = 28, // Error from ESX driver
  FROM_PHYP              = 29, // Error from the phyp driver, unused since 6.0.0
  FROM_SECRET            = 30, // Error from secret storage
  FROM_CPU               = 31, // Error from CPU driver
  FROM_XENAPI            = 32, // Error from XenAPI
  FROM_NWFILTER          = 33, // Error from network filter driver
  FROM_HOOK              = 34, // Error from Synchronous hooks
  FROM_DOMAIN_SNAPSHOT   = 35, // Error from domain snapshot
  FROM_AUDIT             = 36, // Error from auditing subsystem
  FROM_SYSINFO           = 37, // Error from sysinfo/SMBIOS
  FROM_STREAMS           = 38, // Error from I/O streams
  FROM_VMWARE            = 39, // Error from VMware driver
  FROM_EVENT             = 40, // Error from event loop impl
  FROM_LIBXL             = 41, // Error from libxenlight driver
  FROM_LOCKING           = 42, // Error from lock manager
  FROM_HYPERV            = 43, // Error from Hyper-V driver
  FROM_CAPABILITIES      = 44, // Error from capabilities
  FROM_URI               = 45, // Error from URI handling
  FROM_AUTH              = 46, // Error from auth handling
  FROM_DBUS              = 47, // Error from DBus
  FROM_PARALLELS         = 48, // Error from Parallels
  FROM_DEVICE            = 49, // Error from Device
  FROM_SSH               = 50, // Error from libssh2 connection transport
  FROM_LOCKSPACE         = 51, // Error from lockspace
  FROM_INITCTL           = 52, // Error from initctl device communication
  FROM_IDENTITY          = 53, // Error from identity code
  FROM_CGROUP            = 54, // Error from cgroups
  FROM_ACCESS            = 55, // Error from access control manager
  FROM_SYSTEMD           = 56, // Error from systemd code
  FROM_BHYVE             = 57, // Error from bhyve driver
  FROM_CRYPTO            = 58, // Error from crypto code
  FROM_FIREWALL          = 59, // Error from firewall
  FROM_POLKIT            = 60, // Error from polkit code
  FROM_THREAD            = 61, // Error from thread utils
  FROM_ADMIN             = 62, // Error from admin backend
  FROM_LOGGING           = 63, // Error from log manager
  FROM_XENXL             = 64, // Error from Xen xl config code
  FROM_PERF              = 65, // Error from perf
  FROM_LIBSSH            = 66, // Error from libssh connection transport
  FROM_RESCTRL           = 67, // Error from resource control
  FROM_FIREWALLD         = 68, // Error from firewalld
  FROM_DOMAIN_CHECKPOINT = 69, // Error from domain checkpoint
  FROM_TPM               = 70, // Error from TPM
  FROM_BPF               = 71, // Error from BPF code
  FROM_CH                = 72, // Error from Cloud-Hypervisor driver
  ERR_DOMAIN_LAST        = 73
}

ErrorNumber :: enum u32 {
  ERR_OK                        = 0,  
  ERR_INTERNAL_ERROR            = 1,   // internal error
  ERR_NO_MEMORY                 = 2,   // memory allocation failure
  ERR_NO_SUPPORT                = 3,   // no support for this function
  ERR_UNKNOWN_HOST              = 4,   // could not resolve hostname
  ERR_NO_CONNECT                = 5,   // can't connect to hypervisor
  ERR_INVALID_CONN              = 6,   // invalid connection object
  ERR_INVALID_DOMAIN            = 7,   // invalid domain object
  ERR_INVALID_ARG               = 8,   // invalid function argument
  ERR_OPERATION_FAILED          = 9,   // a command to hypervisor failed
  ERR_GET_FAILED                = 10,  // a HTTP GET command to failed
  ERR_POST_FAILED               = 11,  // a HTTP POST command to failed
  ERR_HTTP_ERROR                = 12,  // unexpected HTTP error code
  ERR_SEXPR_SERIAL              = 13,  // failure to serialize an S-Expr
  ERR_NO_XEN                    = 14,  // could not open Xen hypervisor control
  ERR_XEN_CALL                  = 15,  // failure doing an hypervisor call
  ERR_OS_TYPE                   = 16,  // unknown OS type
  ERR_NO_KERNEL                 = 17,  // missing kernel information
  ERR_NO_ROOT                   = 18,  // missing root device information
  ERR_NO_SOURCE                 = 19,  // missing source device information
  ERR_NO_TARGET                 = 20,  // missing target device information
  ERR_NO_NAME                   = 21,  // missing domain name information
  ERR_NO_OS                     = 22,  // missing domain OS information
  ERR_NO_DEVICE                 = 23,  // missing domain devices information
  ERR_NO_XENSTORE               = 24,  // could not open Xen Store control
  ERR_DRIVER_FULL               = 25,  // too many drivers registered
  ERR_CALL_FAILED               = 26, 
  ERR_XML_ERROR                 = 27,  // an XML description is not well formed or broken
  ERR_DOM_EXIST                 = 28,  // the domain already exist
  ERR_OPERATION_DENIED          = 29,  // operation forbidden on read-only connections
  ERR_OPEN_FAILED               = 30,  // failed to open a conf file
  ERR_READ_FAILED               = 31,  // failed to read a conf file
  ERR_PARSE_FAILED              = 32,  // failed to parse a conf file
  ERR_CONF_SYNTAX               = 33,  // failed to parse the syntax of a conf file
  ERR_WRITE_FAILED              = 34,  // failed to write a conf file
  ERR_XML_DETAIL                = 35,  // detail of an XML error
  ERR_INVALID_NETWORK           = 36,  // invalid network object
  ERR_NETWORK_EXIST             = 37,  // the network already exist
  ERR_SYSTEM_ERROR              = 38,  // general system call failure
  ERR_RPC                       = 39,  // some sort of RPC error
  ERR_GNUTLS_ERROR              = 40,  // error from a GNUTLS call
  WAR_NO_NETWORK                = 41,  // failed to start network
  ERR_NO_DOMAIN                 = 42,  // domain not found or unexpectedly disappeared
  ERR_NO_NETWORK                = 43,  // network not found
  ERR_INVALID_MAC               = 44,  // invalid MAC address
  ERR_AUTH_FAILED               = 45,  // authentication failed
  ERR_INVALID_STORAGE_POOL      = 46,  // invalid storage pool object
  ERR_INVALID_STORAGE_VOL       = 47,  // invalid storage vol object
  WAR_NO_STORAGE                = 48,  // failed to start storage
  ERR_NO_STORAGE_POOL           = 49,  // storage pool not found
  ERR_NO_STORAGE_VOL            = 50,  // storage volume not found
  WAR_NO_NODE                   = 51,  // failed to start node driver
  ERR_INVALID_NODE_DEVICE       = 52,  // invalid node device object
  ERR_NO_NODE_DEVICE            = 53,  // node device not found
  ERR_NO_SECURITY_MODEL         = 54,  // security model not found
  ERR_OPERATION_INVALID         = 55,  // operation is not applicable at this time
  WAR_NO_INTERFACE              = 56,  // failed to start interface driver
  ERR_NO_INTERFACE              = 57,  // interface driver not running
  ERR_INVALID_INTERFACE         = 58,  // invalid interface object
  ERR_MULTIPLE_INTERFACES       = 59,  // more than one matching interface found
  WAR_NO_NWFILTER               = 60,  // failed to start nwfilter driver
  ERR_INVALID_NWFILTER          = 61,  // invalid nwfilter object
  ERR_NO_NWFILTER               = 62,  // nw filter pool not found
  ERR_BUILD_FIREWALL            = 63,  // nw filter pool not found
  WAR_NO_SECRET                 = 64,  // failed to start secret storage
  ERR_INVALID_SECRET            = 65,  // invalid secret
  ERR_NO_SECRET                 = 66,  // secret not found
  ERR_CONFIG_UNSUPPORTED        = 67,  // unsupported configuration construct
  ERR_OPERATION_TIMEOUT         = 68,  // timeout occurred during operation
  ERR_MIGRATE_PERSIST_FAILED    = 69,  // a migration worked, but making the VM persist on the dest host failed
  ERR_HOOK_SCRIPT_FAILED        = 70,  // a synchronous hook script failed
  ERR_INVALID_DOMAIN_SNAPSHOT   = 71,  // invalid domain snapshot
  ERR_NO_DOMAIN_SNAPSHOT        = 72,  // domain snapshot not found
  ERR_INVALID_STREAM            = 73,  // stream pointer not valid
  ERR_ARGUMENT_UNSUPPORTED      = 74,  // valid API use but unsupported by the given driver
  ERR_STORAGE_PROBE_FAILED      = 75,  // storage pool probe failed
  ERR_STORAGE_POOL_BUILT        = 76,  // storage pool already built
  ERR_SNAPSHOT_REVERT_RISKY     = 77,  // force was not requested for a risky domain snapshot revert
  ERR_OPERATION_ABORTED         = 78,  // operation on a domain was canceled/aborted by user
  ERR_AUTH_CANCELLED            = 79,  // authentication cancelled
  ERR_NO_DOMAIN_METADATA        = 80,  // The metadata is not present
  ERR_MIGRATE_UNSAFE            = 81,  // Migration is not safe
  ERR_OVERFLOW                  = 82,  // integer overflow
  ERR_BLOCK_COPY_ACTIVE         = 83,  // action prevented by block copy job
  ERR_OPERATION_UNSUPPORTED     = 84,  // The requested operation is not supported
  ERR_SSH                       = 85,  // error in ssh transport driver
  ERR_AGENT_UNRESPONSIVE        = 86,  // guest agent is unresponsive, not running or not usable
  ERR_RESOURCE_BUSY             = 87,  // resource is already in use
  ERR_ACCESS_DENIED             = 88,  // operation on the object/resource was denied
  ERR_DBUS_SERVICE              = 89,  // error from a dbus service
  ERR_STORAGE_VOL_EXIST         = 90,  // the storage vol already exists
  ERR_CPU_INCOMPATIBLE          = 91,  // given CPU is incompatible with host CPU
  ERR_XML_INVALID_SCHEMA        = 92,  // XML document doesn't validate against schema
  ERR_MIGRATE_FINISH_OK         = 93,  // Finish API succeeded but it is expected to return NULL
  ERR_AUTH_UNAVAILABLE          = 94,  // authentication unavailable
  ERR_NO_SERVER                 = 95,  // Server was not found
  ERR_NO_CLIENT                 = 96,  // Client was not found
  ERR_AGENT_UNSYNCED            = 97, 
  ERR_LIBSSH                    = 98,  // error in libssh transport driver
  ERR_DEVICE_MISSING            = 99,  // fail to find the desired device
  ERR_INVALID_NWFILTER_BINDING  = 100,  // invalid nwfilter binding
  ERR_NO_NWFILTER_BINDING       = 101,  // no nwfilter binding
  ERR_INVALID_DOMAIN_CHECKPOINT = 102,  // invalid domain checkpoint
  ERR_NO_DOMAIN_CHECKPOINT      = 103,  // domain checkpoint not found
  ERR_NO_DOMAIN_BACKUP          = 104,  // domain backup job id not found
  ERR_INVALID_NETWORK_PORT      = 105,  // invalid network port object
  ERR_NETWORK_PORT_EXIST        = 106,  // the network port already exist
  ERR_NO_NETWORK_PORT           = 107,  // network port not found
  ERR_NO_HOSTNAME               = 108,  // no domain's hostname found
  ERR_CHECKPOINT_INCONSISTENT   = 109,  // checkpoint can't be used
  ERR_MULTIPLE_DOMAINS          = 110,  // more than one matching domain found
  ERR_NO_NETWORK_METADATA       = 111,  // Network metadata is not present
  ERR_AGENT_COMMAND_TIMEOUT     = 112,  // guest agent didn't respond to a non-sync command within timeout
  ERR_AGENT_COMMAND_FAILED      = 113,  // guest agent responded with failure to a command
  ERR_INVALID_ENCR_KEY_SECRET   = 114,  // encryption key is invalid
  ERR_NUMBER_LAST               = 115
}

ErrorLevel :: enum u32 {
  ERR_NONE	=	0,
  ERR_WARNING	=	1, // A simple warning
  ERR_ERROR	=	2 ,  //	An error
}

Error :: struct {
  code: c.int,        // The error code, a virErrorNumber
  domain: c.int,      // What part of the library raised this error
  message: cstring,   // human-readable informative error message
  level: ErrorLevel,  //  how consequent is the error
  conn: ^Connect,     //  connection if available, deprecated see note above
  dom: ^Domain,       // domain if available, deprecated see note above
  str1: cstring,      // extra string information
  str2: cstring,      // extra string information
  str3: cstring,      // extra string information
  int1: c.int,        //  extra number information
  int2: c.int,        //  extra number information
  net: ^Network       // net network if available, deprecated see note above
}


@(link_prefix = "vir")
foreign vir {

  ConnSetErrorFunc ::proc(conn: ^Connect, user_data: rawptr, handler: proc(user_data: rawptr, error: ^Error)) ---

}
