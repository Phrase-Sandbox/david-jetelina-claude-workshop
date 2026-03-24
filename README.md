# Claude Code Workshop — Practical Skills

**Duration:** ~45 minutes, interactive
**Audience:** Platform/infrastructure engineers who know the basics
**Goal:** Go from "I've tried it" to "I use it effectively and safely"

## Prerequisites

- Claude Code CLI installed and authenticated (`claude` in your terminal)
- This repo cloned locally

## Agenda

| Time | Section | Focus |
|------|---------|-------|
| 3 min | Intro | What we're covering, why it matters |
| 12 min | [Exercise 1: Plan Mode](exercises/01-plan-mode/) | Always plan before executing on infra |
| 15 min | [Exercise 2: CLAUDE.md & Safety](exercises/02-claude-md/) | Writing effective instructions, gating dangerous actions |
| 12 min | [Exercise 3: Skills & Slash Commands](exercises/03-skills/) | Superpowers, /commit, brainstorming |
| 3 min | Wrap-up | Q&A, resources |

## Between Exercises

`/clear` between exercises to reset conversation context. Note: the repo root `CLAUDE.md` is always loaded regardless of which directory you're in — subdirectory CLAUDE.md files stack on top, they don't replace it.

## Key Takeaways

1. **Plan mode is your default for infra work.** Execute mode is for when you've already decided what to do.
2. **CLAUDE.md is instructions, not wishes.** Write it like a runbook — specific, gated, testable.
3. **Skills save you from yourself.** Brainstorming before coding, verification before completion.
4. **You are the reviewer.** If Claude is moving fast and you're not reading, you're the problem.

## After the Workshop

- Add a CLAUDE.md to your team's repos
- Install superpowers: `claude install-skill https://github.com/anthropics/claude-code-superpowers`
- Explore MCP plugins (Datadog, Jira, Slack, Context7) to connect Claude to your stack
