# Exercise 1: Plan Mode

## The Problem

Claude Code in execute mode is reactive — it proposes edits and you review diffs on the spot. That works for simple tasks, but for infrastructure work you want to shape the approach *before* any code changes.

Plan mode flips the dynamic: **you decide what happens, then Claude executes.**

## What to Do

### Step 1: Try execute mode first

Open Claude Code in this directory and say:

```
Clean up this VPC module. It's a mess.
```

Watch what it does. It will probably produce reasonable edits — maybe extract variables, standardize naming, add tags. Don't approve anything yet. Just look at what it chose to do.

Ask yourself:
- Did it ask what "clean up" means, or did it decide for you?
- Would you have made the same choices?
- Did it consider that renaming resource addresses would require `tofu state mv`?

The work might be fine. But **you're reviewing decisions you didn't make.** For a Python script, that's OK. For Terraform managing real infrastructure, you want to be driving.

Hit `Ctrl+C`.

### Step 2: Now use plan mode

Press `Shift+Tab` to enter plan mode (the input indicator changes). Give the same prompt:

```
Clean up this VPC module. It's a mess.
```

Notice the difference:
- It asks what you mean by "clean up"
- It proposes an approach and waits for your input
- No diffs until you agree on what should change

You're shaping the plan instead of reacting to edits.

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
- **Execute mode**: Claude decides what "clean up" means → you review diffs reactively
- **Plan mode**: You decide what "clean up" means → Claude executes your intent

Same tool, same prompt, different dynamic. For infra work, plan mode should be your default.

## Shortcut

`Shift+Tab` toggles between plan and execute mode.

## Key Lesson

The issue with execute mode isn't that Claude does bad work — it usually doesn't. The issue is that **you're reviewing choices you didn't make** instead of making them. Plan mode puts you back in the driver's seat.
