# Room Message Mentions and Delivery Design

**Date:** 2026-09-18  
**Status:** Approved for spec review  
**Scope:** `thought-khoral-contracts`, `thought-khoral-room-gateway`, and `thought-khoral-workspace-ui`

## Goal

Allow a room message to mention one or more known human or agent
participants, while letting the sender choose whether the message is visible
to everyone or delivered only to the mentioned audience. Mentions use the
`@` convention and support the fixed aliases `@allhumans` and `@allagents`.

The delivery rule is authoritative at the gateway. The workspace prevents
unknown mentions for a good editing experience, but the gateway independently
validates every submitted target.

## UX

The room composer uses a mention-aware `@` interaction:

- Typing `@` opens an autocomplete menu containing known room participants.
- Suggestions identify each participant as Human or Agent and expose a
  canonical mention token. The token is `@` plus a lowercase hyphenated slug
  of the participant display name; if two participants produce the same slug,
  append `-` plus the first eight characters of the participant ID. Multiple
  participants can be selected in one message.
- The fixed aliases `@allhumans` and `@allagents` are always available. The
  aliases resolve to all known room participants with the matching role:
  `@allhumans` targets every human participant and `@allagents` targets every
  agent participant.
- A selected mention is rendered in the composer as an `@` token and retained
  as structured mention metadata. The message body remains ordinary text for
  compatibility with the current chat renderer.
- A manually typed, stale, or otherwise unrecognized `@` token is invalid.
  Send is disabled and an inline message explains that mentions must be chosen
  from the suggestion list. A participant that disappears before sending is
  treated as stale and cannot be sent.

The composer includes a delivery selector with two choices:

1. **Everyone in room** — all joined/replaying room participants receive the
   message. Mention metadata remains attached and is visible/highlighted to
   everyone.
2. **Mentioned participants only** — the sender and the resolved mention
   audience receive the message. This choice requires at least one mention.

`@allagents` has an explicit visibility exception: it targets all agent
participants, but all human participants can also see messages addressed to
`@allagents`. This permits humans to supervise agent-directed conversation.
`@allhumans` targets all human participants; agents are not added to that
audience unless they are independently mentioned.

In targeted mode, a direct participant mention targets that participant's
identity regardless of online status. Group aliases are resolved against the
room's known participant roster at send time. The sender always receives a
copy of a message they send.

## Contract changes

The retained `n2n.room.v1` contract gains additive chat delivery fields:

- `chat.send.params.text` remains required.
- `chat.send.params.mentions` is an optional array of at most 50 unique mention
  targets. Each target is a structured participant target (`id` plus its
  canonical token) or one of the fixed aliases `allhumans` and `allagents`.
- `chat.send.params.delivery` is an optional enum with `room` and `mentioned`
  values. It defaults to `room` when absent, preserving old clients.
- `message.created.payload` records the normalized mention metadata and
  delivery mode so that clients can render mentions consistently after replay.
- The normalized event carries the resolved delivery audience needed for
  server-side filtering. The sender is included in that audience for targeted
  messages. The event retains the alias metadata used by the sender so the
  UI can render `@allhumans` or `@allagents` as authored.

The contract imposes a maximum of 50 mention entries and rejects duplicate
targets. The implementation must use one named constant in the schema and
gateway. Unknown participant IDs, unsupported aliases, malformed UUIDs, and
invalid delivery combinations are rejected by the gateway with a safe
validation error. Existing `{ text }` messages remain valid room-wide
messages.

## Gateway behavior

The gateway validates chat mentions after resolving the room's known
participant roster. A known participant is one present in the room participant
snapshot, including participants learned from room history and current
presence. A direct target that is not in that roster is rejected. Aliases are
expanded by role:

- `allhumans`: every known participant whose role is `human`.
- `allagents`: every known participant whose role is `agent` plus every known
  human participant for visibility/supervision.

For `delivery: room`, the event is visible to all room participants. For
`delivery: mentioned`, the event is visible only to the sender and its
normalized audience. The event is still persisted once in the append-only
event stream; targeted delivery is enforced on both live broadcast and replay.

Because room sequence numbers remain global, a connection must advance its
replay cursor across events that are persisted but not visible to that actor.
It must send only events passing the event-audience check and must not treat a
hidden event as a sequence gap.

The existing request fingerprint includes mentions and delivery so a retry
with changed audience data is rejected as a conflicting duplicate. Existing
chat behavior, room joins, presence updates, and idempotent request handling
remain compatible.

## Workspace data flow

`RoomPage` passes the current participant roster to `ChatStream`. `ChatStream`
owns composer state, mention parsing/selection, delivery selection, and the
send validation boundary. On submit it emits a typed chat request containing
the body, selected mention targets, and delivery mode. `RoomPage` sends those
fields through the existing `useRoomSocket` RPC path.

`api.tsx` projects message metadata from `message.created` events. The current
PatternFly message display remains the room transcript, but mention tokens are
rendered with accessible labels and the selected delivery mode is exposed to
every recipient who receives the event. Messages that are not delivered to an
actor never enter that actor's event projection.

## Testing and verification

Contract tests will cover backward-compatible room-wide chat, direct 1:N
mentions, both aliases, targeted delivery fields, duplicate/unknown targets,
and invalid delivery combinations.

Gateway tests will cover direct-target validation, alias expansion, the
`@allagents` human-visibility exception, sender visibility, targeted live
broadcast, targeted replay, hidden-sequence cursor advancement, and request
fingerprint conflicts.

Workspace tests will cover `@` autocomplete, selecting multiple humans and
agents, `@allhumans`, `@allagents`, rejecting unknown/stale tokens, delivery
selection, targeted payload construction, and accessible rendering of mention
metadata.

The owning repository checks remain required: contract fixture validation,
gateway Rust tests, workspace UI tests, TypeScript build, and the workspace
preview smoke test.

## Out of scope

- Private one-to-one channels or a new notification service.
- Durable room membership management beyond the existing participant roster.
- User-configurable aliases beyond `@allhumans` and `@allagents`.
- Mention editing after a message is persisted.
- A protocol major-version bump.
