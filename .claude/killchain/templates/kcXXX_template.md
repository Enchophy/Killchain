# kcXXX <Component Name>

## Overview
[2-3 sentence description of this component's purpose and role in the project]

## Dependencies

### Component Dependencies
[List kcXXX files this depends on, or "None" if first component]
- kcYYY: [Why this dependency is needed]

### External Dependencies
[List libraries, tools, or frameworks needed]
- `library_name`: [Purpose and version if specific]

### Input Requirements
[What this component receives from previous components]
- **Data format:** [Description of input format]
- **Expected types:** [Type specifications]
- **Constraints:** [Any assumptions or requirements about input]

### Output Specifications
[What this component produces for subsequent components]
- **Data format:** [Description of output format]
- **Return types:** [Type specifications]
- **Guarantees:** [What this component guarantees about its output]

## TODO
[ ] High-level task 1
[ ] High-level task 2
[ ] High-level task 3

## Task 1: [Task Name]

### TODO
[ ] Specific sub-task 1.1
[ ] Specific sub-task 1.2
[ ] Specific sub-task 1.3

### Implementation Details

#### Approach
[Describe the recommended implementation approach]

#### Key Considerations
- [Important design decision or constraint]
- [Edge case to handle]
- [Performance consideration]
- [Security consideration if applicable]

#### Type Specifications
```<language>
# Example function signatures with type hints
def function_name(
    param1: Type1,
    param2: Type2,
    optional_param: Type3 = default_value
) -> ReturnType:
    """
    Brief description of what this function does.

    Args:
        param1: Description of param1
        param2: Description of param2
        optional_param: Description of optional parameter

    Returns:
        Description of return value

    Raises:
        ExceptionType: When this specific condition occurs
    """
    pass
```

#### Required Assertions
```<language>
# Type enforcement
assert isinstance(param1, ExpectedType), "param1 must be ExpectedType"

# Domain validation
assert param1 > 0, "param1 must be positive"
assert param2 in VALID_VALUES, f"param2 must be one of {VALID_VALUES}"

# Invariant checking
assert len(result) == expected_length, "Result length mismatch"
```

### Acceptance Criteria
[ ] Function/class `name` correctly handles [specific behavior]
[ ] Function/class `name` validates input types and raises appropriate errors
[ ] All edge cases handled: [list specific edge cases]
[ ] All functions have comprehensive type hints
[ ] All functions have detailed docstrings
[ ] All functions include assertions for type/domain validation
[ ] Unit tests created with >80% coverage
[ ] Integration tests with dependent components (if applicable)
[ ] No TODOs, FIXMEs, or placeholder code
[ ] Code follows project style conventions
[ ] Performance meets requirements: [specific metrics if applicable]

## Task 2: [Task Name]

### TODO
[ ] Specific sub-task 2.1
[ ] Specific sub-task 2.2

### Implementation Details
[Same structure as Task 1]

### Acceptance Criteria
[Same structure as Task 1]

## Testing Strategy

### Unit Tests
[Describe what unit tests should cover]
- **Test case 1:** [Description of what to test]
- **Test case 2:** [Description of what to test]
- **Test case 3:** [Edge case to test]

### Integration Tests
[Describe how this component integrates with others]
- **Integration scenario 1:** [Description]
- **Integration scenario 2:** [Description]

### Edge Cases
[List specific edge cases that must be tested]
- **Edge case 1:** [Description and expected behavior]
- **Edge case 2:** [Description and expected behavior]

## Documentation Requirements

[ ] Inline code documentation (docstrings for all functions/classes)
[ ] Usage examples in docstrings or separate examples file
[ ] API reference documentation (if this is a public API)
[ ] Error handling guide (what exceptions can be raised and why)

## Estimated Complexity

**Complexity Level:** Simple | Medium | Complex

**Estimated Effort:** [hours or story points]

**Justification:** [Why this complexity/effort estimate]

**Risk Factors:**
- [Any technical risks or uncertainties]
- [Dependencies on external services/libraries]
- [Unknown requirements or unclear specifications]

---

**Created:** [timestamp]
**Last Updated:** [timestamp]
**Status:** todo
