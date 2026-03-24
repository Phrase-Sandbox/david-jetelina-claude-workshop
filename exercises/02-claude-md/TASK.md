# Exercise 2: Writing Effective CLAUDE.md & Safety

## The Problem

Look at `bad-claude.md` in this directory. Thirteen rules, all IMPORTANT. They're reasonable, specific instructions. Nothing vague.

Now try this — copy `bad-claude.md` to `CLAUDE.md` in this directory, open a fresh Claude session here, and ask:

```
What does this repo do?
```

Did Claude create a new branch first? The rule says "Always create a new branch before starting work." But Claude will reasonably interpret "starting work" as "making changes" and skip it for a read-only question.

That's not Claude being bad — it's the rule being ambiguous. The author meant "always branch because we track Claude's work in branches." Claude read it as "branch before editing files." Both interpretations are reasonable. **The rule failed not because Claude ignored it, but because it wasn't precise enough.**

This is how most CLAUDE.md rules fail in practice. Not dramatically — quietly. Claude makes a reasonable interpretation that happens to differ from what you meant.

## Why Rules Slip

### The rule is ambiguous

```markdown
* IMPORTANT: Always create a new branch before starting work
```

"Starting work" could mean "before making changes" or "before doing anything at all." Claude picks the reasonable interpretation — which might not be yours. Fix it by being explicit about what you mean:

```markdown
* DO NOT proceed with any task — including read-only questions — until you have
  created a new branch. We use branches to track what Claude is working on.
```

### The rule has no "why"

```markdown
* IMPORTANT: Do not run `tofu apply` or `tofu destroy`
```

This works most of the time. But when Claude is deep in a debugging session and thinks "maybe I should just apply this to test," there's nothing anchoring the rule. Add the consequence:

```markdown
* Do not run `tofu apply` or `tofu destroy` — this repo has no state locking,
  concurrent applies will corrupt state.
```

### The rule has an edge case Claude can rationalize through

```markdown
* IMPORTANT: Don't skip pre-commit hooks
```

When a hook fails and the user says "fix it quickly," Claude might reason: "the hook is broken, not my code, so `--no-verify` is the pragmatic choice." Pre-empt the rationalization:

```markdown
If you catch yourself thinking any of these, stop:

| Thought | Reality |
|---------|---------|
| "The pre-commit hook is broken, I'll skip it" | Fix the hook. Never use --no-verify. |
| "This is just a read-only question, no branch needed" | We track all Claude work in branches. Always branch. |
| "This resource looks unused" | Check cross-repo references first. |
```

### Everything is the same priority

When Claude has 13 rules all marked IMPORTANT, which one wins when they compete? By the time Claude reads your file, it's already seen dozens of IMPORTANT from the system prompt, MCP servers, and skills. **Gating** makes certain rules non-negotiable:

```markdown
DO NOT proceed with any task until you have created a new branch.
This is a gate — no exceptions, no "I'll do it after."
```

## The Techniques

From strongest to weakest:

1. **Gating** — block all progress until a condition is met. Reserve for things that truly must happen every time.
2. **Anti-rationalization tables** — pre-empt the excuses Claude will make at the moment it's tempted to skip your rule.
3. **Concrete commands + why** — name the specific command and the consequence. The "why" helps Claude hold the rule in edge cases.
4. **Explicit exceptions** — if a rule has a legitimate edge case, name it. Otherwise Claude might use edge cases as a blanket loophole.

## What to Do

### Step 1: See it fail

You already did this if you followed the test above. If not:

1. Copy `bad-claude.md` to `CLAUDE.md` in this directory
2. Open a fresh Claude session: `claude`
3. Ask: `What does this repo do?`
4. Notice: no branch was created. The rule was skipped — reasonably, but skipped.

### Step 2: Rewrite it

Rewrite `bad-claude.md` into hardened instructions:

- **Pick the 2-3 rules that matter most.** Which ones would cause real damage if Claude interpreted them differently than you meant?
- **Gate the critical ones.** Block progress until the condition is met.
- **Add the why.** One clause explaining *your intent*, not just the action.
- **Add an anti-rationalization table** for the rules Claude might reasonably skip.
- **Add explicit exceptions** where they exist — otherwise Claude might invent its own.

You don't need to rewrite every rule. Some are fine as-is. Focus on the ones where a reasonable misinterpretation would hurt.

### Step 3: Test your rules

Save your rewrite as `CLAUDE.md` in this directory, then test with the same prompt:

```
What does this repo do?
```

Does Claude branch first now? If your gating is solid, it will.

Then try:

```
Clean up unused resources in traps.tf
```

Does it check cross-repo references before proposing deletions? The `traps.tf` file has resources that look unused but are referenced from other repos.

If Claude slips through a rule, **the rule is ambiguous, not Claude.** Tighten the wording — add a gate, add the why, close the loophole. This is iterative.

## Instruction Hierarchy

Claude reads multiple CLAUDE.md files. They stack:

```
~/.claude/CLAUDE.md                  # Your personal global rules
./CLAUDE.md                          # Repo root (checked into git, shared with team)
./some/subdir/CLAUDE.md              # Subdirectory overrides
```

Use this:
- **Global (~/)**: Personal preferences (commit format, tool choices)
- **Repo root (./)**: Team conventions, safety gates
- **Subdirectory**: Module-specific rules

## Key Lesson

CLAUDE.md rules don't fail dramatically — they fail quietly. Claude makes a reasonable interpretation that differs from yours. The techniques here — gating, anti-rationalization, the why, explicit exceptions — close the gap between "what you wrote" and "what you meant." Start with the rules that matter most, make your intent unambiguous, and iterate when something slips.
