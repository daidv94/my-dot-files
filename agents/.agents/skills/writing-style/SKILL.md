---
name: my-writing-style
description: >
    Structure and format rules for my technical deliverables: README and runbook layout, how-to sections, code blocks, and inline code review comments.
    Use together with the eng-core-voice skill, which sets voice, word choice, and punctuation.
    Use this skill when writing or editing a README, runbook, onboarding guide, Confluence page, or code review comment, when the user says "write this up" or "make it sound like me", or when the output should match a doc the user approved before.
---

# My writing style

This skill sets structure and format. The eng-core-voice skill sets voice, word choice, and punctuation, including the no em dash rule. Load both. Where they overlap, eng-core-voice wins.

The goal is writing that respects the reader's time. Every sentence moves the reader forward, or it goes.

## Core rules

**Instructions:** Start with a verb. "Create the directory", not "You'll need to create the directory".

**Active voice by default.** Passive is fine when the object deserves the emphasis. "Secrets are pulled from GCP Secret Manager" keeps the focus on where, which is the point. Use passive on purpose, not by habit.

**Direct instructions.** In steps and recommendations, cut "you may want to", "consider", "feel free to", "it might be worth". Say what to do. Hedge a claim only when the facts warrant it, as eng-core-voice describes.

**No filler.** Remove on sight:
- "Please note that…" / "Keep in mind…" / "It's worth mentioning…"
- "This will allow you to…" / "In order to…" / "As mentioned above…"
- Any sentence that summarizes the previous sentence
- Trailing confirmations ("This ensures everything works correctly")

**Trust the reader.** Don't re-explain what a code block just showed. Don't confirm what the previous sentence already implied.

## Structure

**Prose for explanations and reasoning.** Use bullets only when items are parallel and enumerable, in the bold-lead form from eng-core-voice ("**Label:** one-sentence explanation"). Use tables for comparisons.

**Numbered steps only when order matters** and each item is a discrete action.

**Code blocks** for anything copy-pasteable: commands, YAML, config snippets. Backticks for short inline references to filenames, flags, and keys.

**Inline comments instead of prose explanations** when the subject is in a code block:

```yaml
infras:
  clusters:
    - project: workloads
      region: us-east4
      cluster: primary   # label must match cluster-name secret label
```

## Output formats by deliverable type

### README / runbook

Order: overview → structure → how-to steps → edge cases / appendix.

Lead each how-to section with the file path or command pattern, then explain. Keep explanations in prose. Reserve bullets for lists that are truly enumerable.

### PR description and commit message

Follow the Git commit and PR rules in AGENTS.md.

### Inline code review comment

One sentence stating the issue, and optionally one sentence with the fix or rationale. No preamble, no softening.

## Tone calibration

Write for a senior engineer. Skip basics. Be direct about trade-offs and risks: if something has a footgun, say so. If the answer is simple, say it's simple.
