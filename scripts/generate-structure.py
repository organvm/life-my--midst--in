#!/usr/bin/env python3
"""
scripts/generate-structure.py

Scaffolds the monorepo directory structure and placeholder files.
"""

import argparse
from pathlib import Path
from textwrap import dedent

# ---------- Configuration ----------

# Directories to create relative to repo root
DIRS = [
    "apps",
    "apps/web",
    "apps/web/src",
    "apps/api",
    "apps/api/src",
    "apps/worker",
    "apps/worker/src",
    "packages",
    "packages/core",
    "packages/core/src",
    "packages/ui",
    "packages/ui/src",
    "packages/config",
    "packages/config/src",
    "infra",
    "infra/terraform",
    "infra/k8s",
    "docs",
    ".github",
    ".github/workflows",
    "scripts",
]

# Files to create: path -> content (relative to repo root)
FILES = {
    # Apps container
    "apps/README.md": dedent(
        """\
        # Apps

        This folder contains runnable applications (frontends, backends, workers).
        - `web/`    – Interactive CV UI
        - `api/`    – Backend API / orchestration
        - `worker/` – Background workers / jobs
        """
    ),

    # Web app
    "apps/web/README.md": dedent(
        """\
        # Web App (Interactive CV)

        Frontend application for the interactive CV/résumé.
        - Tech: React/TypeScript (assumed; adjust as needed)
        - Entry: `src/index.tsx`
        """
    ),

    # API app
    "apps/api/README.md": dedent(
        """\
        # API Service

        Backend service powering the interactive CV/résumé.
        - Entrypoint: `src/main.py`
        - Responsibilities: APIs, data orchestration, inference routing.
        """
    ),

    # Worker app
    "apps/worker/README.md": dedent(
        """\
        # Worker Service

        Background processing for the interactive CV:
        - async jobs
        - scheduled tasks
        - model precomputation / indexing
        """
    ),

    # Packages container
    "packages/README.md": dedent(
        """\
        # Shared Packages

        Reusable libraries shared across apps:
        - `core/`   – Domain logic and shared models
        - `ui/`     – Shared UI components (for web apps)
        - `config/` – Central configuration and settings
        """
    ),

    # Core package
    "packages/core/README.md": dedent(
        """\
        # Core Package

        Holds core domain logic, entities, and services for the interactive CV.
        """
    ),

    # UI package
    "packages/ui/README.md": dedent(
        """\
        # UI Package

        Shared UI components for the interactive CV frontends.
        """
    ),

    # Config package
    "packages/config/README.md": dedent(
        """\
        # Config Package

        Central configuration, environment handling, and typed settings.
        """
    ),

    # Infra
    "infra/README.md": dedent(
        """\
        # Infrastructure

        Infrastructure-as-code and deployment configuration:
        - `terraform/` – cloud resources
        - `k8s/`       – Kubernetes manifests
        """
    ),

    # GitHub workflows
    ".github/README.md": dedent(
        """\
        # GitHub Configuration

        GitHub-specific configuration, such as Actions workflows.
        """
    ),

    # Scripts
    "scripts/README.md": dedent(
        """\
        # Scripts

        Utility and automation scripts for this monorepo.
        - `generate-structure.py` – scaffolds the directory tree and placeholders.
        """
    ),
}

# ---------- Implementation ----------

def detect_repo_root() -> Path:
    """
    Assume this script lives in `scripts/` under the repo root.
    """
    script_path = Path(__file__).resolve()
    if script_path.parent.name == "scripts":
        return script_path.parent.parent
    return Path.cwd()

def ensure_dirs(root: Path) -> None:
    for rel in DIRS:
        path = root / rel
        path.mkdir(parents=True, exist_ok=True)

def write_files(root: Path, force: bool = False) -> None:
    for rel, content in FILES.items():
        path = root / rel
        if path.exists() and not force:
            print(f"SKIP (exists): {rel}")
            continue
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        print(f"WRITE: {rel}")

def main():
    parser = argparse.ArgumentParser(
        description="Scaffold the monorepo directory structure and placeholder files."
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite existing files instead of skipping them.",
    )
    args = parser.parse_args()

    repo_root = detect_repo_root()
    print(f"Repo root: {repo_root}")

    ensure_dirs(repo_root)
    write_files(repo_root, force=args.force)

    print("Scaffolding complete.")

if __name__ == "__main__":
    main()
