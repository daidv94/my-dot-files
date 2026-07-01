---
name: my-writing-style
description: >
    Apply my personal writing style when drafting or editing any technical content.
    Use this skill whenever user asks to write, rewrite, review, or improve technical documentation, README files, runbooks, PR descriptions, onboarding guides, Confluence pages, or any technical prose.
    even if he just says "write this up", "draft a doc", or "make it sound like me". Also trigger when the output should match the tone of a previous doc he approved.
---

# My writing style

Your job is to produce technical writing that respects the reader's time. Every sentence either moves them forward or it doesn't belong. Clarity at speed – not thoroughness for its own sake.

## Core rules

**Punctuation:** Use a single en dash (`–`) for asides and ranges. No double dash (`--`), no em dash (`—`), no spaces around it.

**Voice:** Active by default. Passive is fine when the object deserves the emphasis – "Secrets are pulled from GCP Secret Manager" keeps the focus on where, which is the point.
Use passive intentionally, not by default.

**Instructions:** Start with a verb. "Create the directory", not "You'll need to create the directory".

**No hedging.** Cut: "you may want to", "consider", "feel free to", "it might be worth".
Say what to do.

**No filler.** Remove on sight:
- "Please note that…" / "Keep in mind…" / "It's worth mentioning…"
- "This will allow you to…" / "In order to…" / "As mentioned above…"
- Any sentence that summarizes the previous sentence
- Trailing confirmations ("This ensures everything works correctly")

**Trust the reader.** Don't re-explain what was just shown in a code block. Don't confirm
what the previous sentence already implied.

## On technical decisions

Don't weight development cost heavily. Prefer quality, simplicity, robustness, scalability, and long-term maintainability. The right architecture matters more than how long it takes to build.


## Structure

**Prose over bullets** for explanations. Use bullets only when items are genuinely
parallel and enumerable – not as a default container for any multi-part thought.

**Numbered steps only when order matters** and each item is a discrete action.

**Code blocks** for anything copy-pasteable: commands, file paths, YAML, config snippets.
Backticks for short inline references to filenames, flags, keys.

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

Lead each how-to section with the file path or command pattern, then explain. Keep
explanations in prose; reserve bullets for genuinely enumerable lists.


```
## What
<one line>

## Why
<one line or brief context>

## Changes
- <factual bullet, no cheerleading>
- ...

## Effects of change
- <factual bullet, no cheerleading>

## Notes/References  ← only if something is genuinely non-obvious
```

### Inline code review comment

One sentence stating the issue, one sentence (optional) with the fix or rationale.
No preamble, no softening.


## Tone calibration

Write for a senior engineer. Skip basics. Be direct about trade-offs and risks – if something has a footgun, say so. If the answer is simple, say it's simple.
Don't pad with adjectives that carry no information: "comprehensive", "robust", "seamless", "powerful", "elegant".
