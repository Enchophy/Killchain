# KillChain: Status Report

Generate a comprehensive status report for the current KillChain project.

## Status Report Process

### 1. Verify KillChain Project

Check for required files:
```bash
ls .kcplan/killchain_context.json
ls .kcplan/kc*.md
```

If not found, inform user this is not a KillChain project.

### 2. Load Project Data

**Read Context:**
`.kcplan/killchain_context.json`

**Count Components:**
```bash
# Total components
ls .kcplan/kc*.md | wc -l
```

**Read Status from Context:**
Component statuses are tracked in `killchain_context.json` under the `component_status` field:
```json
{
  "component_status": {
    "kc001": "completed",
    "kc002": "completed",
    "kc003": "in_progress",
    "kc004": "todo"
  }
}
```

Count by parsing this JSON structure.

### 3. Generate Status Report

Present to user in markdown format:

```markdown
# KillChain Status Report
**Project:** <project_name>
**Generated:** <current_timestamp>

## Progress Overview

### Completion Status
- **Total Components:** <total>
- **Completed:** <completed> (<percentage>%)
- **In Progress:** <active> components
- **Pending:** <todo> components

### Current Component
- **ID:** <current_component>
- **Name:** <component_name>
- **Status:** <status_description>
- **Started:** <timestamp if available>

### Progress Bar
[████████████████░░░░░░░░] <percentage>%

## Timeline

- **Started:** <started_at>
- **Last Updated:** <last_updated>
- **Total Time:** <calculate duration>
- **Components Completed:** <count>
- **Average Time per Component:** <calculate>

### Time Estimates
- **Estimated Remaining:** <calculate based on velocity>
- **Estimated Completion:** <projected date/time>
- **Confidence:** ±<range> (based on variance)

## Component Breakdown

### Completed ✓
<list of completed components with brief description>

### In Progress ⚙
<list of active components with current stage>

### Pending ○
<list of todo components>

## Quality Metrics

- **Tests Written:** <count if trackable>
- **Code Reviews:** <count completed reviews>
- **E2E Tests:** <count and status>
- **Blockers Resolved:** <count>

## Current Blockers
<list active blockers if any>

## Recent Activity
<last 5-10 significant actions from context>

## Decisions Made
<count of decisions in decisions_made array>
<latest 3 decisions>

## Budget Status
<if tracking API costs>
- **Estimated Cost:** $<calculate>
- **Average per Component:** $<calculate>
- **Budget Health:** On track / Warning / Over budget
```

### 4. JSON Output Option

If user requests machine-readable format, also output JSON:

```json
{
  "project_name": "...",
  "timestamp": "...",
  "progress": {
    "total_components": 0,
    "completed": 0,
    "in_progress": 0,
    "pending": 0,
    "percentage": 0.0
  },
  "current_component": {
    "id": "kcXXX",
    "name": "...",
    "status": "...",
    "stage": "development|qa|review|e2e"
  },
  "timeline": {
    "started_at": "...",
    "last_updated": "...",
    "total_duration_hours": 0.0,
    "avg_time_per_component_hours": 0.0
  },
  "estimates": {
    "remaining_hours": 0.0,
    "estimated_completion": "...",
    "confidence_interval": "±X hours"
  },
  "quality": {
    "tests_written": 0,
    "code_reviews_completed": 0,
    "e2e_tests_run": 0,
    "blockers_active": 0,
    "blockers_resolved": 0
  },
  "components": {
    "completed": ["kc001", "kc002"],
    "active": ["kc003"],
    "pending": ["kc004", "kc005"]
  },
  "blockers": [],
  "recent_activity": [],
  "decisions_made": 0
}
```

### 5. Advanced Analytics (Optional)

If sufficient data exists, include:

**Velocity Chart (text-based):**
```
Components per day:
Day 1: ███████ 7
Day 2: █████ 5
Day 3: ████████ 8
```

**Component Complexity:**
```
Simple (<2hrs):   ████████ 40%
Medium (2-6hrs):  ██████████████ 50%
Complex (>6hrs):  ███ 10%
```

**Stage Breakdown:**
```
Average time spent:
Development: ████████████ 60%
QA:          ████ 20%
Review:      ██ 10%
E2E:         ██ 10%
```

## Status Check Variations

### Quick Status
Just show progress percentage and current component:
```
KillChain: 47% complete (kc015 in progress)
```

### Detailed Status
Full report as shown above.

### Component-Specific Status
If user provides component number:
```
/killchain-status kc015
```

Show detailed status for that specific component:
```markdown
# Component Status: kc015

**Name:** <component_name>
**Status:** <status>
**File:** .kcplan/kc015_<status>_<name>.md

## Progress
- [ ] Task 1 (completed)
- [ wip ] Task 2 (in progress)
- [ ] Task 3 (pending)

## Current Stage
<development|qa|review|e2e>

## History
- Created: <timestamp>
- Started: <timestamp>
- Last updated: <timestamp>

## Files Modified
<list implementation files>

## Tests
<test status if available>
```

## Important Notes

- Status reports are read-only - no modifications
- All timestamps should be human-readable
- Include confidence intervals for estimates
- Highlight blockers prominently
- Update estimates based on actual velocity

---

Generate the status report now.
