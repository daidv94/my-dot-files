---
name: create-jira-ticket
description: >-
  Creates Jira tickets (Epic, Story, Task) in the IA project using the Atlassian
  MCP. Use when the user says "create a ticket", "create a Jira issue", "open a
  ticket for X", "log this as a bug/task/story", or any similar phrasing.
  Requires Atlassian MCP configured with Jira access.
---

# Create Jira Ticket

## Requirements

- **Atlassian MCP** must be configured with Jira access.
- Fallback if MCP unavailable: produce a formatted ticket block for the user to paste manually.

## Workflow

1. **Gather context** — if any required field is missing, ask before proceeding:
   - `summary` (title) — required
   - `issue_type` — Epic, Story, or Task (default: Task)
   - `description` — ask if not obvious from context
   - `parent` — required for Story/Task if it belongs under an Epic

2. **Resolve the cloud ID** — use `atlassian_getAccessibleAtlassianResources` if not cached.

3. **Create the ticket** — call `atlassian_createJiraIssue` with:
   - `cloudId` — from step 2
   - `projectKey` — `IA`
   - `issueTypeName` — Epic | Story | Task
   - `summary` — the ticket title
   - `description` — formatted in markdown
   - `parent` — Epic key if creating a Story/Task under one

4. **Confirm** — report back the created issue key and URL.

## Output format

After creation, reply with:

```
Created: [IA-XXX] <summary>
URL: https://<site>.atlassian.net/browse/IA-XXX
Type: <Epic | Story | Task>
```

## Description template

When drafting the description, use this structure:

```
## What
<what needs to be done>

## Why
<business or technical reason>

## Acceptance Criteria
- [ ] ...
- [ ] ...

## Notes
<links, references, or anything else relevant>
```

When writing the description prose, apply the `my-writing-style` skill for tone and voice.
Keep it concise. Skip sections that have nothing meaningful to say.

## Issue type guidance

| Type  | Use when |
|-------|----------|
| Epic  | Large feature or initiative spanning multiple stories |
| Story | User-facing capability or deliverable under an Epic |
| Task  | Technical or operational work item; may stand alone or belong to an Epic |
