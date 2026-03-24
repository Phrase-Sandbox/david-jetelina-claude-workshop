# Exercise 1: Plan Mode

## The Problem

Claude Code in execute mode is fast — it reads the code, makes decisions, and proposes edits. That's great for simple tasks. But for infrastructure work, the problem isn't the quality of the edits — it's that **Claude decided the scope for you.**

Plan mode flips the dynamic: **you decide what happens, then Claude executes.**

## What to Do

### Step 1: Try execute mode first

Open Claude Code in this directory and say:

```
Clean up this VPC module — fix the inconsistent naming, add tags, and make CIDR blocks configurable.
```

Watch what it does. It'll read the module and immediately start making decisions. Don't approve anything yet. Just look at what it *chose* to do — and what it chose to *ignore*.

Ask yourself:
- You said "fix naming" — did it fix the tag names, the resource names, or both? Did it ask which you meant?
- What about the hardcoded availability zones? The missing NAT gateway tags? Did it decide those were out of scope, or did you?
- It probably made reasonable choices. But they were *its* choices, not yours. Would you have prioritized differently?

The work is probably fine. But you're reviewing a scope you didn't set. For a Python script, no big deal. For Terraform managing production infrastructure, you want to be the one deciding what changes and what doesn't.

Hit `Ctrl+C`. If you already approved changes, run `git checkout .` to reset the files before continuing.

### Step 2: Now use plan mode

Press `Shift+Tab` to enter plan mode (the input indicator changes). Give the same prompt:

```
Clean up this VPC module — fix the inconsistent naming, add tags, and make CIDR blocks configurable.
```

Notice the difference:
- It asks clarifying questions instead of deciding for you
- It proposes an approach and waits for your input
- No diffs until you agree on the scope

You're setting the scope instead of reacting to someone else's choices.

### Step 3: Be specific

Still in plan mode, try a specific prompt:

```
This VPC module has hardcoded CIDR blocks, inconsistent subnet naming (pub1 vs priv_2), and no tags. I want to:
1. Make CIDR blocks configurable via variables
2. Standardize naming to use for_each with a map
3. Add Name/Team/Environment tags to all resources
Don't rename existing resource addresses — we can't break state.
```

Notice how the plan is now precise and safe. That last constraint — "don't rename resource addresses" — is the kind of thing you think of *when you have space to think*. Plan mode gives you that space.

### Step 4: Compare

Think about the two experiences:
- **Execute mode**: Claude decided what "clean up" means, what's in scope, what to skip → you review
- **Plan mode**: You decide what's in scope, what to skip, what constraints matter → Claude executes

Same tool, same prompt, different dynamic. For infra work, plan mode should be your default.

## Shortcut

`Shift+Tab` toggles between plan and execute mode.

## Key Lesson

The issue with execute mode isn't that Claude does bad work — it usually doesn't. The issue is that **Claude decided the scope for you.** What got fixed, what got ignored, what trade-offs were made — those were all Claude's calls, not yours. Plan mode puts you back in the driver's seat.
