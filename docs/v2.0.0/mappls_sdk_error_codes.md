# Mappls SDK – Error Handling Guide

This document describes how the **Mappls SDKs** handle errors internally. The following error codes and messages will help developers debug integration issues more effectively.

---

## Core SDK Errors

| Condition | Exception/Error Message |
|----------|--------------------------|
| `.a.olf` file is missing in the project | `No .a.olf file found. The Mappls Services Plugin cannot function without it.` |
| `.conf` config file is missing from bundle | `.conf file not found in bundle` |
| `.olf` file is invalid or corrupted | `Please add a valid .olf configuration file.` |
| Package name or app fingerprint mismatch in `.olf` file | `You are using Invalid Configuration. Please check your Package Name / App Fingerprint & download it from the developer console again.` |
| `.conf` config file is invalid | `Please add a valid .conf configuration file.` |
| Static key is missing (improper setup or missing plugin) | `Error Code: 1`
`Error Message: Static Key Not Found`
_No HTTP status code associated_ |
| Invalid payload during JSON creation | `Error Code: 2`
`Error Message: Invalid Payload`
_No HTTP status code associated_ |
| Missing config data, `appId`, or `payloadPubKey` | `Error Code: 3`
`Error Message: Invalid Config`
_No HTTP status code associated_ |
| Payload encryption failure | `Error Code: 3`
`Error Message: Invalid Payload`
_No HTTP status code associated_ |
| Auth1 Token missing or expired (during API call) and config download fails | `Error Code: 5`
`Error Message: Authentication Failed`
_No HTTP status code associated_ |
| Auth1 authentication attempted but access token missing from config | `Error Code: 6`
`Error Message: This authentication is not supported`
_No HTTP status code associated_ |
| Method not provisioned | `Error Code: 4`
`Error Message: Method not Provisioned`
_No HTTP status code associated_ |

---

## Map SDK Errors

| Condition | Exception/Error Message |
|----------|--------------------------|
| Config is not read properly by Map SDK (improper setup) | `Error Code: 7`
`Error Message: Map Config not available` |
| `vectorMap` object or style base URL missing in config | `Error Code: 7`
`Error Message: Map Info is not available` |
| Public key or its expiry missing from `vectorMap` object in config | `Error Code: 8`
`Error Message: Public Key not found` |

---

### Note
- All errors listed are internal SDK exceptions.
- These do **not** return standard HTTP status codes.
- Ensure your `.olf` and `.conf` files are correctly configured and downloaded from the [Mappls Developer Console](https://developer.mappls.com/).
- Always apply the necessary Mappls plugins and dependencies to your Android project.