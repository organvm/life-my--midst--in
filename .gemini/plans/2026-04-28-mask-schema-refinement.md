# Implementation Plan - Mask Schema Refinement

This plan outlines the steps to refine the `MaskSchema` in `packages/schema` to align with the archetypal definitions in ADR-005 and ensure structural integrity across the identity system.

## 1. Schema Refinement (packages/schema/src/mask.ts)

- [ ] **Add Ontology Mapping**: Define a mapping between `MaskType` (e.g., 'analyst') and its canonical `Ontology` (e.g., 'cognitive').
- [ ] **Update MaskSchema**:
    - [ ] Add `type: MaskType` field.
    - [ ] Update `id` to be a unique string (allowing for custom masks based on archetypes).
    - [ ] Ensure all theatrical metadata (nomen, role_vector, tone_register, visibility_scope, motto) is properly typed and documented.
    - [ ] Add a `refine` block to ensure that if a `type` is provided, the `ontology` matches its canonical definition.

## 2. Test Updates (packages/schema/test/schemas.test.ts)

- [ ] **Update Valid Mask Fixture**: Update the `validMask` used in tests to include the new `type` field.
- [ ] **Add Constraint Tests**:
    - [ ] Test that an invalid `type` is rejected.
    - [ ] Test that an ontology mismatching the `type` is rejected.
    - [ ] Test that theatrical metadata (Latin names, etc.) is correctly parsed.

## 3. Data Integration (packages/content-model/src/taxonomy.ts)

- [ ] **Synchronize Taxonomy**: Ensure `MASK_TAXONOMY` in the content model includes the new `type` field and complies with the updated schema.

## 4. Orchestrator Alignment (Optional/Discovery)

- [ ] **Check Role Consistency**: Briefly review if `apps/orchestrator/src/agents.ts` roles should be mapped to specific default masks for task reporting.
