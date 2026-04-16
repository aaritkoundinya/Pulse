# Pulse

Single-repo KiCad workspace for all Pulse board revisions.

## Repository Structure

- `boards/r2/` - imported from your existing `pulser2`
- `boards/r2.1/` - imported from your existing `pulser2.1`
- `templates/scratch-board/` - starter template for clean-slate revisions
- `tools/new_revision.sh` - helper script to create new revisions

Each board folder has its own KiCad-focused `.gitignore`.

## Create New Revisions

Build from an existing revision:

```bash
./tools/new_revision.sh r3 --from r2.1
```

Start from scratch:

```bash
./tools/new_revision.sh r3 --scratch
```

After creation, open KiCad and work in `boards/<revision>/`.
