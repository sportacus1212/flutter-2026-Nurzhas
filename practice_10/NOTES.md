# Practice 10 Notes

## Postman API Analysis

### Top-Level Fields (User)
| Field | JSON Type | Dart Type | Nullable? |
| --- | --- | --- | --- |
| id | number | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| address | object | Address | No |
| phone | string | String | No |
| website | string | String? | Yes |
| company | object | ({String name, String catchPhrase}) | No |

### Address Fields
| Field | JSON Type | Dart Type | Nullable? |
| --- | --- | --- | --- |
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### Geo Fields
| Field | JSON Type | Dart Type | Nullable? |
| --- | --- | --- | --- |
| lat | string | double | No |
| lng | string | double | No |

### Company Fields
| Field | JSON Type | Dart Type | Nullable? |
| --- | --- | --- | --- |
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | String | No |

### Status Responses & Notes
* GET https://jsonplaceholder.typicode.com/users/999: Status 404, Body: `{}`
* POST https://jsonplaceholder.typicode.com/users: Status 201 Created. Body includes requested keys plus server-assigned `id: 11`.
* GET https://jsonplaceholder.typicode.com/users?id=3: Response shape is a List containing 1 map item `[{...}]`.

## Network Test Timings
* Airplane mode (SocketException): ~0.15s (Immediate OS failure route)
* Dead Wi-Fi / No-Route Hotspot (TimeoutException): ~10.00s (Enforced 10-second timeout)