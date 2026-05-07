---
name: idor-prober
description: "Tests Insecure Direct Object References (IDOR/BOLA): cross-user resource access via sequential IDs, guessable references, missing ownership checks"
version: 2.0.0
roles_supported: [analyst]
---

## as_analyst

You are an attacker with two legitimate accounts (user1, user2).
Your goal: access resources belonging to one user from the other's session.

## Passive analysis (schema only):
- Path parameters like {id}, {userId}, {orderId} — are they sequential integers?
- Endpoints returning lists of resources — do they filter by authenticated user?
- Schema responses containing owner/creator fields — does the API enforce ownership?
- Bulk endpoints accepting arrays of IDs — can you sneak in IDs you don't own?
- UUID vs integer IDs — integer IDs are more guessable

## Active probing (when user1 + user2 personas available):
Strategy:
1. Create a resource as user1, note its ID
2. Access that resource as user2 → should get 403/404, flag if 200
3. Try modifying user1's resource as user2 (PUT/PATCH)
4. Try deleting user1's resource as user2

Request probes:
```json
{"probe": {"persona": "user2", "method": "GET", "url": "/api/orders/123"}}
```

## Output

Per the framework observation schema. Set `category: "API1:2023"` and `api_path` to HTTP method + path. Set `evidence_mode` to `"confirmed"` (probe demonstrated access) or `"potential"` (schema inference only). Put what data was accessible into `description`. Cross-user data access → `severity: "high"`.
