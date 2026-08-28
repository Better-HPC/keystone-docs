# Getting Started

The Keystone Python Client provides a simple, streamlined interface for 
interacting with the Keystone REST API. By abstracting away low level API 
mechanics, the client allows developers to easily implement custom workflows 
and automate day-to-day tasks.

The client package is published on the BHPC registry and can be installed 
using any standard Python package manager:

=== "pip"

    ```sh
    BHPC_REPO="https://dl.cloudsmith.io/public/better-hpc/keystone/python/simple/"
    pip install --extra-index-url=$BHPC_REPO keystone-api-client
    ```

=== "uv"

    ```sh
    BHPC_REPO="https://dl.cloudsmith.io/public/better-hpc/keystone/python/simple/"
    uv add --index=$BHPC_REPO keystone-api-client
    ```

=== "poetry"

    ```sh
    BHPC_REPO="https://dl.cloudsmith.io/public/better-hpc/keystone/python/simple/"
    poetry source add --priority=supplemental bhpc $BHPC_REPO
    poetry add keystone-api-client
    ```


## Instantiating a Client

The`KeystoneClient` class is used to authenticate new API sessions and issue synchronous HTTP calls.
The `AsyncKeystoneClient` class provides an identical interface, but with support for async operations.

In the following example a new client session is created for a locally running server on port `8000`.
Creating the session with a context manager ensures open connections are automatically closed when no longer in use.

=== "Synchronous"

    ```python
    from keystone_client import KeystoneClient

    with KeystoneClient(url="http://localhost:8000") as client:
        ... # Your synchronous code here
    ```

=== "Asynchronous"

    ```python
    from keystone_client import AsyncKeystoneClient

    async with AsyncKeystoneClient(url="http://localhost:8000") as aclient:
        ... # Your asynchronous code here
    ```

Sessions can also be opened and closed manually, although this approach is generally discouraged as it can introduce
accidental resource leaks from unclosed connections.

=== "Synchronous"

    ```python
    from keystone_client import KeystoneClient

    client = KeystoneClient(url="http://localhost:8000")
    # Your synchronous code here
    client.close()
    ```

=== "Asynchronous"

    ```python
    from keystone_client import AsyncKeystoneClient

    aclient = AsyncKeystoneClient(url="http://localhost:8000")
    # Your asynchronous code here
    await aclient.close()
    ```

## Authenticating a Session

The `login` and `logout` methods are used to handle user authentication.
Once authenticated, the client will automatically manage the resulting session tokens.

=== "Synchronous"

    ```python
    from keystone_client import KeystoneClient

    with KeystoneClient(url="http://localhost:8000") as client:
        client.login(username="username", password="password")
        assert client.is_authenticated()
        client.logout()
    ```

=== "Asynchronous"

    ```python
    from keystone_client import AsyncKeystoneClient

    async with AsyncKeystoneClient(url="http://localhost:8000") as aclient:
        await aclient.login(username="username", password="password")
        assert await aclient.is_authenticated()
        await aclient.logout()
    ```

Metadata for the currently authenticated user is available via the `whoami` method.
Calling this method is functionally equivalent to issuing an HTTP GET call to the `/authentication/whoami/` endpoint.

=== "Synchronous"

    ```python
    from keystone_client import KeystoneClient

    with KeystoneClient(url="http://localhost:8000") as client:
        client.login(username="username", password="password")
        iam = client.wmoami()
        print(iam)
    ```

=== "Asynchronous"

    ```python
    from keystone_client import AsyncKeystoneClient

    async with AsyncKeystoneClient(url="http://localhost:8000") as aclient:
        await aclient.login(username="username", password="password")
        iam = await aclient.wmoami()
        print(iam)
    ```

## Making API Requests

Both client classes provide a dedicated method for each HTTP request type.
Any relevant session/authentication tokens are included automatically when submitting requests.

| HTTP Method | Function Name | Description                                              |
|-------------|---------------|----------------------------------------------------------|
| `GET`       | `http_get`    | Retrieve data from the server at the specified resource. |
| `POST`      | `http_post`   | Submit a new record to be processed by the server.       |
| `PUT`       | `http_put`    | Replace an existing record with a new one.               |
| `PATCH`     | `http_patch`  | Partially update an existing record.                     |
| `DELETE`    | `http_delete` | Remove the specified record from the server.             |

Request/response logic is handled using the `httpx` library.
API responses are returned as `httpx.Response` objects which encapsulate the response data and status code.
Users are encouraged to familiarize themselves with the `httpx` library and it's methods for parsing response
data and related metadata.
A simple example is provided below.

=== "Synchronous"

    ```python
    from keystone_client import KeystoneClient

    with KeystoneClient(url="http://localhost:8000") as client:
        response = client.http_get('version')

    response.raise_for_status()
    print(response.status_code)
    print(response.content)
    ```

=== "Asynchronous"

    ```python
    from keystone_client import AsyncKeystoneClient

    async with AsyncKeystoneClient(url="http://localhost:8000") as aclient:
        response = await aclient.http_get('version')

    response.raise_for_status()
    print(response.status_code)
    print(response.content)
    ```
