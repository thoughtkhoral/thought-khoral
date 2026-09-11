# 002 — Browser WebSocket authentication

## Status

Accepted

## Decision

The MVP authenticates browser WebSocket connections through an initial `session.authenticate` JSON-RPC message rather than an HTTP `Authorization` upgrade header, URL query parameter, or `Sec-WebSocket-Protocol` credential.

The browser opens an unauthenticated WebSocket and sends an OIDC access token only in that first application message. The gateway allows no room operation until it validates issuer, audience, signature, key identifier, algorithm, expiry, and not-before claims and binds the resulting identity and role to the connection. It closes connections that do not authenticate within a short configured timeout.

The gateway uses an explicit origin allowlist at the WebSocket handshake, performs authorization for every room method, revalidates session/token lifetime for long-lived connections, and never logs credentials or raw room content for rejected requests.

## Rationale

Browser WebSocket APIs cannot attach arbitrary HTTP authorization headers. Query-string credentials risk appearing in access logs. `Sec-WebSocket-Protocol` is a protocol-negotiation mechanism rather than a credential channel. Initial-message authentication retains token-based identity while avoiding URL exposure.

## Consequences

- The gateway and UI must implement the `session.authenticate` contract before the browser MVP can run end to end.
- Authentication has a brief unauthenticated connection state, limited solely to the authentication message and timeout handling.
- A future same-origin BFF session-cookie design remains possible, but requires its own approved decision covering CSWSH and CSRF controls.
