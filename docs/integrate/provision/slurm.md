# Configuring Slurm

Slurm is a batch job scheduler commonly deployed on research focused HPC
clusters. By default, Slurm provides limited, rudimentary controls to enforce
resource limits and track resource consumption. Keystone integrates with these
controls to providing automatic resource provisioning.

Keystone is agnostic to most Slurm settings and requires minimal modification
to an existing cluster. However, certain fairshare features are incompatible
with Keystone's accounting model and must be disabled. The steps below outline
the configuration required for integration with Slurm.

## How Slurm Works

Slurm reports system utilization in terms of trackable resources (TRES). Each
TRES value represents a different system resource, including CPU, GPU, memory,
and others. Keystone uses these TRES values to enforce limits on a Slurm
account's **_total billable usage_**.

By default, the billable usage for a given Slurm job is calculated as the TRES
usage $\left ( U \right )$ scaled by administrator-defined billing weights
$\left ( W \right )$ summed over all resource types $\left ( R \right )$.
This value is also commonly referred to as an HPC _service unit_.

$$
\text{Billable Usage} = \sum_\text{R} \,\, \left ( W_\text{R} * U_\text{R} \right )
$$

!!! Warning

    The above calculation assumes the Slurm `PriorityFlags` setting is 
    disabled. Modifying `PriorityFlags` may cause Slurm to use an alternative
    calculation and can lead to unexpected behavior. See the official 
    [Slurm documentation](https://slurm.schedmd.com/slurm.conf.html#OPT_PriorityFlags)
    for more details.

Keystone interfaces with Slurm to automatically enforce per-cluster limits on a
group's total Billable Usage. In Slurm these limits are reflected by the
`GrpTresMins=billing=[LIMIT]` setting. Once a group reaches this limit, Slurm
will prevent the group from running additional jobs on the target cluster.

## Enable Resource Tracking

To impose usage limits, Keystone requires the utilized resources to be
represented as a TRES in Slurm. Usage tracking is enabled by default for
common resources such as CPU and memory. Administrators may extend this list
to include additional resource types, such as GPUs.

The `AccountingStorageTRES` setting is used to extend which TRES values are
stored in the Slurm database. Further information on Slurm supported TRES
values can be found in the [Slurm documentation](https://slurm.schedmd.com/tres.html#conf).

??? Example "Example: Tracking GPU usage"

    To extend the default TRES list with tracking for GPU resources:

    ```
    AccountingStorageTRES=gres/gpu
    ```

??? Example "Example: Tracking GPU and IOP"

    To extend the default TRES list with tracking for GPU resources 
    and a license-based resource named `iop1`:

    ```
    AccountingStorageTRES=gres/gpu,license/iop1
    ```

## Disable Usage Decay

Slurm defaults to using the [multifactor priority plugin](https://slurm.schedmd.com/priority_multifactor.html) to
schedule jobs.
To verify this, inspect the `PriorityType` setting:

```bash
scontrol show config | grep PriorityType
```

When using the multifactor plugin, the `PriorityDecayHalfLife` and
`PriorityUsageResetPeriod` settings need to be disabled. These settings cause
Slurm to reduce recorded usage over time, which interferes with Keystone's
accounting calculations.

```
PriorityDecayHalfLife=00:00:00
PriorityUsageResetPeriod=NONE
```

!!! Important

    Disabling the `PriorityDecayHalfLife` and `PriorityUsageResetPeriod` 
    settings may affect your Slurm fairshare policy. Administrators are 
    strongly encouraged to review their existing policy before changing 
    these values.

## Configure Charging Rates

TRES billing weights default to zero and must be explicitly defined using 
the `TRESBillingWeights` option. Weights are set per partition and can be
expressed in a variety of units. See the [Slurm documentation](https://slurm.schedmd.com/tres.html) for 
full details.

??? Example "Example: Billing for CPU"

    To only charge users for CPU usage:

    ```
    PartitionName=partition_name TRESBillingWeights="CPU=1.0"
    ```

??? Example "Example: Billing for CPU and GPU"

    To charge GPU usage at twice the rate of CPU usage:

    ```
    PartitionName=partition_name TRESBillingWeights="CPU=1.0,GRES/gpu=2.0"
    ```
