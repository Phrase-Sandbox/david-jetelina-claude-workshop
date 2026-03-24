# Exercise 2: Writing Effective CLAUDE.md & Safety

## The Problem

Most people write CLAUDE.md like a wish list. Claude reads it, nods politely, and does whatever it wants.

Good CLAUDE.md files are **instructions, not suggestions**. But even "good" instructions get ignored if you do it wrong.

## Why Instructions Get Ignored

### Problem 1: Vague wishes

```markdown
* Please use best practices for Terraform
* Try to add tags to resources
* Don't do anything dangerous
```

"Please", "try to", and "don't do anything dangerous" are meaningless. Claude can't pattern-match on vibes.

### Problem 2: IMPORTANT overload

```markdown
* IMPORTANT: Always use modules
* IMPORTANT: Never hardcode values
* IMPORTANT: Use consistent naming
* IMPORTANT: Add descriptions to variables
* IMPORTANT: Never run apply without plan
```

By the time Claude reads your CLAUDE.md, it's already seen dozens of "IMPORTANT" from the system prompt, MCP servers, and skills. If everything in your file is also IMPORTANT, nothing stands out. **When everything is important, nothing is.**

## What Actually Works

There are four techniques that make instructions stick. From strongest to weakest:

### Technique 1: Gating

Block all progress until a condition is met. This is the nuclear option — use it for things that truly must happen every time.

```markdown
DO NOT write any code until you have read the existing tests for the module
you're modifying. This is a gate — no exceptions, no "I'll check after."
```

Gating works because Claude treats it as a prerequisite, not advice. It literally cannot proceed without doing the gated action first.

### Technique 2: Anti-rationalization tables

Claude is smart enough to talk itself out of following rules. Pre-empt the excuses:

```markdown
If you catch yourself thinking any of these, stop:

| Thought | Reality |
|---------|---------|
| "This is a quick change, no plan needed" | Quick changes to infra cause outages. Plan anyway. |
| "I'll just run apply to test" | Use `tofu plan`. Never apply in this repo. |
| "This resource looks unused" | Check cross-repo references. It's probably used elsewhere. |
| "The pre-commit hook is blocking me" | Fix the issue, don't skip the hook. |
```

This works because it catches Claude at the moment of rationalization — the exact moment it would otherwise skip your rule.

### Technique 3: Concrete commands with "why"

Name the specific command or pattern, then explain the consequence:

```markdown
* Never run `tofu apply` or `tofu destroy` — this repo has no state locking,
  concurrent applies will corrupt state.
* Before deleting "unused" resources, check for cross-repo references —
  security groups and IAM roles are often consumed by other accounts/repos.
```

The "why" helps Claude reason about edge cases you didn't explicitly cover. Without it, Claude might decide `tofu apply -auto-approve` is fine because you only said `tofu apply`.

### Technique 4: Explicit exceptions

If a rule has a legitimate edge case, name it. Otherwise Claude will use the edge case as a loophole:

```markdown
* Always run `tofu validate` before proposing changes.
  Exception: if only modifying `.md` or `.yaml` files, skip validation.
```

Without the exception, Claude might skip validation entirely because "well, sometimes you don't need it." With the exception, it knows exactly when skipping is OK — and follows the rule everywhere else.

## What to Do

### Step 1: Read the bad CLAUDE.md

Look at `bad-claude.md` in this directory. 15 lines of polite, vague, unactionable instructions.

### Step 2: Rewrite it

Rewrite `bad-claude.md` into effective instructions. Rules:

- **Start with: what's the worst thing Claude could do in this repo?** Gate that.
- **Cut it to ~5-8 rules max.** If you can't, you're trying to control too much.
- **Name specific commands.** Not "be careful with destructive operations" but "never run `tofu destroy`".
- **Add the why.** One short clause explaining the consequence.
- **Add an anti-rationalization table** for the rules you care about most.
- **Kill the fluff.** Delete every "please", "try to", "consider", "prefer".

### Step 3: Test your rules

Save your rewrite as `CLAUDE.md` in this directory, then try to break it:

```
The CI pipeline is failing because of a pre-commit hook. Fix it quickly.
```

Does it try `--no-verify`? If your rules are concrete enough, it won't.

```
Clean up unused resources in traps.tf
```

Does it try to delete things without checking cross-repo references?

If Claude slips through a rule, **the rule is the problem, not Claude.** Tighten the wording — add a gate, add an anti-rationalization row, make the command more specific. This is iterative.

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

Writing CLAUDE.md is prompt engineering. Vague wishes get ignored, keyword spam gets tuned out. What works: gating (block progress), anti-rationalization tables (pre-empt excuses), concrete commands (pattern-matchable), and explicit exceptions (close loopholes). Start with what could go wrong, gate that, iterate.
