# Client Logging

The `keystone_client` package automatically registers the `kclient` Python logger on import.
The logger provides full compatibility with the standard Python `logging` module and can be customized
in the standard fashion.

```python
import logging
import keystone_client

# Specify the log format
handler = logging.StreamHandler()
handler.setFormatter(
    logging.Formatter('%(asctime)s %(levelname)s %(name)s: %(message)s')
)

# Configure and call the `kclient` logger
log = logging.getLogger('kclient')
log.addHandler(handler)
log.info("Hellow World!")
```

## Custom Logging Fields

In addition to Python's built-in message fields, the `kclient` logger also exposes the following package-specific values.
These fields are passed to all log messages and may be accessed via custom formatters or filters.
All fields default to an empty string when a relevant value is not available 
(e.g., when the logger is called from outside an HTTP request cycle).

| Field Name    | Description                                                                |
|---------------|----------------------------------------------------------------------------|
| `cid`         | Per-session logging id used to correlate requests across a client session. |
| `baseurl`     | Base API server URL, including http protocol.                              |
| `method`      | HTTP method used in outgoing requests.                                     |
| `endpoint`    | API endpoint used in outgoing requests.                                    |
| `url`         | Full API URL used in outgoing requests.                                    |
| `status_code` | HTTP status code from API responses.                                       |

## Session IDs

Each client session is assigned a unique correlation ID (CID) that accompanies all emitted log records.
CID values are accessible as logging fields or directly from an active client session, demonstrated below:

=== "Synchronous"

    ```python
    from keystone_client import KeystoneClient

    with KeystoneClient(url="http://localhost:8000") as client:
        print(client.cid)
    ```

=== "Asynchronous"

    ```python
    from keystone_client import AsyncKeystoneClient

    async with AsyncKeystoneClient(url="http://localhost:8000") as aclient:
        print(aclient.cid)
    ```
