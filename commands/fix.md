---
description: Propose (and optionally apply) an AI fix for a review finding
argument-hint: <file> — <what's wrong>
---
Use the `propose_fix` tool for this finding: $ARGUMENTS

Call it WITHOUT apply first and show me the proposed diff. Only call again with `apply=true` after I confirm. If the apply is refused (target text missing or not unique), tell me — don't guess.
