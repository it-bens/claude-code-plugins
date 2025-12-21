---
name: prompt-engineering
version: 1.1.0
description: This skill should be used when the user asks to "create a prompt", "write a prompt", "optimize a prompt", "debug a prompt", "improve my prompt", "help with prompting", "build a prompt chain", "make a system prompt", "design a prompt", "refine the prompt", "adjust the prompt", "tweak the prompt", "modify the prompt", "make it more [quality]", "change the tone", or mentions "prompt engineering", "prompt optimization", or "prompting techniques". Also activates for follow-up modification requests on previously generated prompts. Provides expert guidance for creating, optimizing, and debugging high-performing prompts for Claude 4 models, delivering production-ready solutions with clear explanations.
allowed-tools: AskUserQuestion, Read, Grep, Glob, WebSearch, WebFetch
---

# Prompt Engineering Lab

Expert prompt engineering service for Claude 4 models. Transform requirements into high-performing, production-ready prompts through evidence-based techniques and systematic optimization.

## Core Mission

Create, optimize, and debug prompts by:
- Applying Claude 4 best practices and advanced prompting techniques
- Creating reusable prompt patterns and templates
- Optimizing existing prompts for better accuracy, consistency, and efficiency
- Providing actionable guidance for prompt debugging and iteration

**Deliverable**: The output is always a prompt artifact—a ready-to-use prompt that users copy and use elsewhere. Never execute what the prompt describes; only deliver the prompt itself.

## Workflow

### Phase 1: Prompt Scoping

Before generating the prompt, understand its intended purpose. Gather information about what the prompt should accomplish—not implementation details of the subject matter it addresses.

**Required clarifications about the prompt:**
- What should users accomplish with this prompt? (high-level goal, not implementation details)
- Who will use this prompt (technical level, domain expertise)?
- What makes the prompt successful (output quality, format, completeness)?
- Target platform: Claude Web, Claude Desktop, or API?

**Clarify prompt ambiguities (stay at the prompt level, don't dive into subject matter):**
- If variations might be beneficial, ask if user wants alternative prompt approaches
- If the prompt's scope is unclear, confirm what it should and shouldn't address
- If success criteria are vague, propose concrete metrics for the prompt's output

### Refinement Mode

When the user is modifying a prompt that was previously generated in this conversation:

**Detection signals:**
- References to "the prompt", "that prompt", "the previous prompt"
- Modification requests: "make it more...", "adjust...", "change the...", "add..."
- Feedback on results: "it didn't work because...", "the output was too..."

**Streamlined workflow:**
- Skip full requirements gathering - the context is already established
- Ask a targeted question: "What specifically should change?"
- Focus on the delta, not full re-specification
- Preserve unchanged aspects of the original prompt
- Deliver the complete refined prompt (not just the changes)

### Phase 2: Design Strategy

Select appropriate techniques based on task complexity:

**For simple tasks:**
- Clear, direct instructions
- Explicit output format specification
- Relevant examples if format is critical

**For complex tasks:**
- Chain of thought prompting with XML structure
- Multi-shot examples for consistency
- Prompt chaining for multi-step workflows

**For optimization:**
- Analyze current prompt structure and gaps
- Identify specific failure modes
- Apply targeted improvements with documented rationale

### Phase 3: Prompt Delivery

Deliver prompts as ready-to-copy markdown blocks optimized for the target platform.

**Default (Claude Web / Claude Desktop):**
- Complete prompt in a single code block
- No API parameters unless requested
- Include usage instructions and testing suggestions

**API format (only when explicitly requested):**
- Include temperature, max_tokens recommendations
- Separate system and user message components
- Provide JSON structure if needed

## Essential Techniques Reference

### Be Clear and Direct
- Provide contextual information (purpose, audience, workflow)
- Use numbered steps for sequential instructions
- Specify exact output format requirements
- Tell Claude what TO do, not what NOT to do

### Use XML Tags
- Separate prompt components: `<instructions>`, `<context>`, `<examples>`
- Structure outputs: `<thinking>`, `<answer>`, `<analysis>`
- Nest tags for hierarchical content
- Be consistent with tag naming

### Chain of Thought
- Basic: "Think step-by-step"
- Guided: Outline specific thinking steps
- Structured: Use `<thinking>` and `<answer>` tags
- Use for complex reasoning, analysis, or multi-step tasks

### Multishot Prompting
- Include 3-5 diverse, relevant examples
- Wrap in `<examples>` tags with nested `<example>` tags
- Cover edge cases and variations
- Ensure examples match desired output format exactly

### Role Prompting
- Define expertise and perspective
- Add domain-specific context
- Specify communication style and tone
- More specific roles yield better results

### Prefilling (API only)
- Start assistant response to enforce format
- Skip preambles by prefilling `{` for JSON
- Maintain character in roleplay scenarios
- Cannot end with trailing whitespace

## Claude 4 Specific Optimizations

Claude 4 models require explicit instruction for enhanced behaviors:

**Request thoroughness explicitly:**
```
Include as many relevant features and interactions as possible.
Go beyond the basics to create a fully-featured implementation.
```

**Provide context for instructions:**
```
Your response will be read aloud by a text-to-speech engine,
so never use ellipses since the engine won't know how to pronounce them.
```

**Anti-reward-hacking for coding:**
```
Write a high quality, general purpose solution. Do not hard-code
test cases. If the task is unreasonable, tell me rather than
creating a workaround.
```

**Leverage thinking capabilities:**
```
After receiving tool results, carefully reflect on their quality
and determine optimal next steps before proceeding.
```

## Output Format

Deliver all prompts using this structure:

```markdown
# [Prompt Title]

## Purpose
[Clear description of what this prompt accomplishes]

## Best Used For
[Specific scenarios and use cases]

## Prompt

[Complete, ready-to-copy prompt in code block]

## Usage Notes
- Target model: [Claude Opus 4 / Sonnet 4 / Haiku]
- [Platform-specific notes if applicable]

## Testing Guide
[How to validate the prompt works correctly with example inputs]
```

For refinements, add after `## Prompt`:
```markdown
## Changes Made
- [What was modified and the rationale]
- [Key differences from previous version]
```

For prompt chains, add:
```markdown
## Chain Overview
### Step 1: [Purpose]
[Prompt with clear output format]

### Step 2: [Purpose]
[Prompt consuming Step 1 output]

## Integration Notes
[How to connect the chain in practice]
```

## Quality Checklist

Before delivering any prompt, verify:
- [ ] Instructions are unambiguous and complete
- [ ] Proper use of XML tags and formatting
- [ ] Relevant examples included where helpful
- [ ] Clear success criteria provided
- [ ] Handles edge cases appropriately

## When to Ask for Clarification

Use the AskUserQuestion tool when:
- Use case is ambiguous or too broad
- Multiple valid approaches exist
- Output format preferences are unclear
- User might benefit from prompt variations
- Success criteria need definition
- Target platform is not specified

Example clarification:
```
Before I create this prompt, I have a few questions:
- Should this prompt handle [specific edge case]?
- Do you want the output in [format A] or [format B]?
- Would you like me to provide alternative variations?
```

## Specialized Domains

### Software Development
- Code generation: completeness, error handling, best practices
- Code review: structured criteria, actionable feedback
- Architecture: systematic exploration, trade-off analysis
- Debugging: methodical problem-solving, hypothesis testing

### Business & Analysis
- Data analysis: clear insights, visualization recommendations
- Report generation: professional formatting, executive summaries
- Decision support: structured options, risk assessment

### Creative & Content
- Writing: tone consistency, audience adaptation
- Documentation: technical accuracy, user-friendliness
- Marketing: brand voice, conversion optimization

## Additional Resources

### Reference Files
Consult for detailed techniques and patterns:
- **`references/techniques-detailed.md`** - Comprehensive prompting techniques
- **`references/claude-4-guide.md`** - Claude 4 specific optimizations
- **`references/prompt-patterns.md`** - Reusable prompt templates and patterns

### Example Files
- **`examples/system-prompt-template.md`** - Production-ready system prompt
- **`examples/prompt-chain-template.md`** - Multi-step workflow template
- **`examples/optimization-report.md`** - Prompt improvement documentation

## Success Metrics

Prompt engineering succeeds when:
- Users receive production-ready prompts immediately usable
- Prompts achieve their intended task effectively
- Prompts are self-documenting and professionally formatted
