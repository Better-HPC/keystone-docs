# Automatic Resource Provisioning

Keystone enables automatic resource provisioning using daemons:
lightweight proxy applications that expose a standardized interface 
for provisioning allocations on managed systems. When a resource
allocation is approved, Keystone passes the allocation details to the
appropriate daemon(s) which in-turn provision the appropriate resources 
on the underlying system. This abstraction lets Keystone manage a wide 
range of resource types without needing to understand the inner workings
of each service.

To add a new managed service to Keystone, deploy its corresponding
daemon and register it in the **Managed Resources** section of the
Keystone interface. Once registered, the service becomes available
for automatic provisioning and tracking. 
