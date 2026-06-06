-- Performance optimization indexes for In Midst My Life

-- Masks table
CREATE INDEX IF NOT EXISTS idx_masks_created_at ON masks(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_masks_name ON masks(name);
CREATE INDEX IF NOT EXISTS idx_masks_ontology ON masks(ontology);
CREATE INDEX IF NOT EXISTS idx_masks_contexts ON masks USING GIN (contexts);
CREATE INDEX IF NOT EXISTS idx_masks_triggers ON masks USING GIN (triggers);
