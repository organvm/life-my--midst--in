import { z } from 'zod';

/**
 * Enumeration of the three primary identity ontologies.
 */
export const OntologySchema = z.enum(['cognitive', 'expressive', 'operational']);
export type Ontology = z.infer<typeof OntologySchema>;

/**
 * Enumeration of the 16 standard mask archetypes.
 */
export const MaskTypeSchema = z.enum([
  'analyst',
  'synthesist',
  'observer',
  'strategist',
  'speculator',
  'interpreter',
  'artisan',
  'architect',
  'narrator',
  'provoker',
  'mediator',
  'integrator',
  'executor',
  'steward',
  'custodian',
  'calibrator',
]);
export type MaskType = z.infer<typeof MaskTypeSchema>;

/**
 * Mapping of MaskType to its canonical Ontology.
 */
export const MASK_ONTOLOGY_MAP: Record<MaskType, Ontology> = {
  analyst: 'cognitive',
  synthesist: 'cognitive',
  observer: 'cognitive',
  strategist: 'cognitive',
  speculator: 'cognitive',
  interpreter: 'cognitive',
  artisan: 'expressive',
  architect: 'expressive',
  narrator: 'expressive',
  provoker: 'expressive',
  mediator: 'expressive',
  integrator: 'expressive',
  executor: 'operational',
  steward: 'operational',
  custodian: 'operational',
  calibrator: 'operational',
};

/**
 * Schema for an identity mask - a contextual presentation of self.
 *
 * Masks are the core innovation of this system. Rather than maintaining separate CVs,
 * a single source-of-truth profile is filtered/transformed through masks to create
 * context-specific presentations. Each mask represents a different facet of identity
 * optimized for different audiences.
 *
 * Properties:
 * - `id`: Unique identifier for this mask
 * - `name`: Human-readable name (e.g., "Technical Lead", "Academic Researcher")
 * - `type`: The standard archetype this mask is based on
 * - `ontology`: The conceptual framework this mask operates within (cognitive, expressive, operational)
 * - `functional_scope`: What professional/personal domains this mask covers
 * - `stylistic_parameters`: How to present content (tone, rhetoric, detail level)
 */
export const MaskSchema = z
  .object({
    id: z.string(),
    name: z.string(),
    type: MaskTypeSchema,

    // Theatrical metadata (explicit self-awareness of performance)
    nomen: z.string().optional().describe('Latin name of this theatrical persona'),
    role_vector: z
      .string()
      .optional()
      .describe('Functional vector: what this mask does and enables'),
    tone_register: z
      .string()
      .optional()
      .describe('Tonal register: how this mask speaks and presents'),
    visibility_scope: z
      .array(z.string())
      .optional()
      .describe('Scaenae (theatrical stages) where this mask is visible and appropriate'),
    motto: z.string().optional().describe('Latin epigraph or guiding principle for this persona'),

    // Functional parameters
    ontology: OntologySchema,
    functional_scope: z.string(),
    stylistic_parameters: z.object({
      tone: z.string(),
      rhetorical_mode: z.string(),
      compression_ratio: z.number().min(0).max(1),
    }),
    activation_rules: z.object({
      contexts: z.array(z.string()),
      triggers: z.array(z.string()),
    }),
    filters: z.object({
      include_tags: z.array(z.string()),
      exclude_tags: z.array(z.string()),
      priority_weights: z.record(z.number().positive()),
    }),
    redaction: z
      .object({
        private_tags: z.array(z.string()).optional(),
        excluded_entities: z.array(z.string()).optional(),
        obfuscate_dates: z.boolean().optional(),
      })
      .optional(),
  })
  .refine(
    (data) => {
      // Enforce that ontology matches the archetype's canonical ontology
      return MASK_ONTOLOGY_MAP[data.type] === data.ontology;
    },
    {
      message: 'Mask ontology must match its archetypal type definition',
      path: ['ontology'],
    },
  );

/**
 * Type representation of a mask object.
 */
export type Mask = z.infer<typeof MaskSchema>;
