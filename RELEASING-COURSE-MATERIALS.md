# Releasing course materials

The repository uses two unrelated local branches.

- `course-source` contains the complete notes, slides, and assignments. Keep this branch local.
- `main` contains the public site. Every unreleased page is a short placeholder with its scheduled availability date.

Because the branches have unrelated histories, the complete source does not appear in the history of `main`. The sidebar remains complete on both branches.

## Check the schedule

Run this command from either branch:

```bash
python3 scripts/release_course.py status
```

The command lists every module and assignment, its current state, and its scheduled availability date. The dates and one-sentence synopses are stored in `release-schedule.json`.

## Release a module

Use the module ID printed by the status command. For instance, the following command releases the random variables module:

```bash
python3 scripts/release_course.py release random-variables-and-distributions
```

The script checks that tracked files are clean, switches to `main` if necessary, restores the complete notes and matching slide deck from `course-source`, updates the slide index, and renders the site. Add `--no-render` if you only want to update the source files. Slide sources for later modules remain only on `course-source`.

## Release an assignment

Use the problem-set ID:

```bash
python3 scripts/release_course.py release ps1
```

Releasing the first problem set also releases the assignments overview. Later problem sets leave the overview available and restore only the requested assignment.

## Commit or post a release

Add `--commit` to render and commit the release on `main`:

```bash
python3 scripts/release_course.py release ps1 --commit
```

Once an `origin` remote has been configured, add `--push` to render, commit, and push in one command:

```bash
python3 scripts/release_course.py release ps1 --push
```

The script never pushes `course-source`.

## Preview a change

Add `--dry-run` to print the affected pages without changing them:

```bash
python3 scripts/release_course.py release statistical-inference --dry-run
```

## Return material to its placeholder

The `hide` command is useful if a module or assignment was released too early:

```bash
python3 scripts/release_course.py hide ps1
```

It uses the same `--no-render`, `--commit`, `--push`, and `--dry-run` options as `release`.

## Edit unreleased material

Do all substantive editing on `course-source`, then commit those changes locally. A later release always copies the most recently committed version from that branch. The release script refuses to switch branches while tracked changes are uncommitted, so an unfinished edit cannot be lost during a release.

Do not merge `course-source` into `main`. The release script copies only the requested pages and preserves the separate branch histories.
