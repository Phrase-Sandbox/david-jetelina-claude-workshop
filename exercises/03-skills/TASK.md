# Exercise 3: Skills — Packaged Team Recipes

## What Are Skills?

Skills are reusable workflows that Claude Code executes automatically. Think of them like pre-commit hooks for your AI workflow — except instead of linting code, they enforce *how work gets done*.

A skill is just a markdown file with instructions. Nothing magic. Your team can write them to encode any workflow you repeat.

## What to Do

### Step 1: Look inside a real skill

Skills aren't black boxes. Let's look at a serious one — the [code-review](https://github.com/anthropics/claude-code/blob/main/plugins/code-review/commands/code-review.md) skill that ships with Claude Code. Open that link and read through it.

This is a multi-agent code review workflow:
- Pre-flight checks (is the PR a draft? already reviewed?)
- Parallel bug-hunting agents scanning the diff
- CLAUDE.md compliance auditing
- A validation step that filters false positives before commenting

It's ~100 lines of markdown. No code, no API, no framework — just structured instructions. That's all a skill is.

Key things to notice:
- The `allowed-tools` in the frontmatter controls what the skill can do
- The `description` determines when it triggers (both `/code-review` slash command and contextual invocation work)
- The body uses the same techniques from Exercise 2 — gating ("if any condition is true, stop"), specific commands (`gh pr diff`), concrete steps
- Frontmatter controls invocation: by default both you and Claude can trigger a skill. Set `disable-model-invocation: true` to make it slash-command-only, or `user-invocable: false` to make it Claude-only

> **Note:** This skill's source lives under `commands/` in the plugin directory. That's a legacy convention — `commands/` and `skills/` work identically, but `skills/` is the recommended path going forward.

### Step 2: Write your own skill

Now create one. Think of a workflow your team repeats — something where you've seen mistakes or where people skip steps. Some ideas:

- **Migration safety**: Before modifying a resource address, check if it requires `tofu state mv` and warn
- **PR checklist**: Before creating a PR, verify tests pass, conventional commit messages, and no secrets in diff
- **Dependency check**: Before adding a new provider or module source, check if the team has an approved version

Pick one (or invent your own) and write it. Skills live in a directory with a `SKILL.md` file:

```bash
# In your terminal (not Claude), create the skill directory:
mkdir -p ~/.claude/skills/my-workshop-skill
```

Then tell Claude:

```
Help me write a skill for [your workflow]. The skill file goes at ~/.claude/skills/my-workshop-skill/SKILL.md
```

Use the techniques from Exercise 2:
- **Gate** the critical steps (don't let Claude skip ahead)
- **Be specific** about commands and checks
- **Add the why** so Claude can reason about edge cases

### Step 3: Test your skill

Try to trigger your skill by giving Claude a task it should apply to. Then try to break it — give a prompt that might tempt Claude to skip the workflow.

Did it hold? If not, tighten the wording — add a gate, make a command more specific. Same iterative process as Exercise 2, but now you're encoding it as a reusable recipe instead of a one-off CLAUDE.md rule.

## Key Lesson

Skills are just team runbooks in a format Claude can follow. The code-review skill you read in step 1 is the same kind of thing as the skill you wrote in step 2 — packaged instructions that enforce a workflow. Any repeated process your team has ("always check X before Y", "never do Z without confirming") can be a skill. Write them like you'd write CLAUDE.md: specific, gated, with the why.
