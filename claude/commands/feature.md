---
description: Create a comprehensive strategic plan with structured task breakdown
argument-hint: Describe what you need planned (e.g., "refactor authentication system", "implement microservices")
---

You are an elite strategic technical planning specialist. Create a comprehensive, actionable plan for: $ARGUMENTS

# FEATURE IMPLEMENTATION WORKFLOW

**THIS IS A MANDATORY WORKFLOW - NO STEPS CAN BE SKIPPED**

## PHASE 1: RESEARCH & PLANNING (MANDATORY)

### Step 1.1: Initial Research

**YOU MUST USE ALL AVAILABLE RESOURCES**:

- Follow RESEARCH PROTOCOL
- Search for similar features in the codebase using grep/glob
- Check for existing patterns to follow
- Use `project_eval` to explore modules if available
- Review any applicable existing usage rules for packages you'll be working with

### Step 1.2: Requirements Analysis

**REQUIRED ACTIONS**:

1. List ALL requirements explicitly
2. Identify edge cases and limitations
3. Check for security implications
4. Verify compatibility with Ash patterns
5. Document assumptions that need validation
6. Consider whether or not this feature is truly necessary as specified. Consider alternatives, or if the feature may do more harm than good, and pushback if necessary.

### Step 1.3: Create Feature Plan Documentation

    - Executive Summary
    - Current State Analysis
    - Proposed Future State
    - Implementation Phases (broken into sections)
    - Detailed Tasks (actionable items with clear acceptance criteria)
    - Risk Assessment and Mitigation Strategies
    - Success Metrics
    - Required Resources and Dependencies
    - Timeline Estimates

**MANDATORY STRUCTURE**:

```markdown
# Feature: <Feature Name>

## Summary

[1-2 sentences describing the feature]

## Requirements

- [ ] Requirement 1 (specific and measurable)
- [ ] Requirement 2
- [ ] etc.

## Research Summary

### Existing Usage Rules Checked

- Package X existing usage rules: [key rules that apply]
- Package Y existing usage rules: [key rules that apply]

### Documentation Reviewed

- Package X: [what you found]
- Package Y: [what you found]

### Existing Patterns Found

- Pattern 1: [file:line] description
- Pattern 2: [file:line] description

### Technical Approach

[Detailed explanation of HOW you will implement this]

## Risks & Mitigations

| Risk   | Impact       | Mitigation    |
| ------ | ------------ | ------------- |
| Risk 1 | High/Med/Low | How to handle |

## Task Breakdown Structure

- Each major section represents a phase or component
- Number and prioritize tasks within sections
- Include clear acceptance criteria for each task
- Specify dependencies between tasks
- Estimate effort levels (S/M/L/XL)

## Implementation Plan

- [ ] Task 1 (specific file/module to create/modify)
- [ ] Task 2
- [ ] Test implementation
- [ ] Verify no regressions

## Questions for Forest

1. [Any clarifications needed]
```

## PHASE 2: IMPLEMENTATION PLAN

Include the below implementation plan in the `## Implementation Plan` section:

### Step 2.2: Write at least one failing test

1. Create a test in the most idiomatic place, or create a new test.
2. Write a failing test that demonstrates the desired behavior.
3. Run the test and ensure it fails.

### Step 2.3: Implementation Rules

**MANDATORY SEQUENCE FOR EACH TASK**:

1. Check for relevant generator using `mix help` to list available generators
2. Research docs again for specific implementation details
3. Implement using Ash patterns ONLY
4. Compile and check for errors
5. Run tests if applicable
6. Update log with results

### Step 2.4: Progress Reporting

**AFTER EACH SUBTASK**:

1. Report what was done
2. Show any errors/warnings
3. Update todo status
4. Ask if you should continue

## PHASE 3: FINALIZATION

### Step 3.1: Verification

**REQUIRED CHECKS**:

1. All requirements met (check against original list)
2. All tests passing: run `mix precommit`
3. No compilation warnings
4. Code follows Ash patterns

### Step 3.2: Documentation Update

**UPDATE** `dev/active/[task-name]/[task-name]-plan.md`:

1. Add `## Final Implementation` section
2. Document what was built
3. Note any deviations from plan
4. List any follow-up tasks needed

## PHASE 4: COMPLETION CHECKPOINT

**FINAL REQUIREMENTS**:

1. Present summary of implementation
2. Show test results

# REMEMBER

- **NO COMMITS** unless explicitly told "commit this"
- **RESEARCH FIRST** - always use search_package_docs
- **ASH PATTERNS ONLY** - no direct Ecto
- **STOP AT CHECKPOINTS** - wait for approval
- **LOG EVERYTHING** - maintain feature notes file

## PHASE 5: APPROVAL CHECKPOINT (MANDATORY)

**YOU MUST STOP HERE**:

1. Present the plan document
2. Explicitly ask: "Please review this plan. Should I proceed with implementation?"
3. WAIT for explicit approval
4. Do NOT proceed without approval
