# Domain profiles

A repository declares one word in its own `.agentsmith/contexts/<name>/context.yaml`:

```yaml
meta:
  workdir: "."
  domain: data-warehouse
```

That word names a directory here. The profile it points at brings the toolchain image
the repository's sandbox runs in and the ordered commands the run is verified by, so the
repository states WHAT it is instead of restating HOW to build it.

## Shape

`profiles/<name>/profile.yaml`:

```yaml
name: data-warehouse          # must equal the directory name
image: <toolchain image>      # trusted registry, git-bearing tag
compatible_images:            # optional
  - <another image known to carry the same tools>
verify:                       # ordered; run top to bottom, stopping at the first failure
  - stage: <label>
    command: <shell command>
    when_present: <path>      # optional; see below
```

## Rules the packaging gate enforces

- `name` equals the directory name.
- `image` is present, comes from a trusted registry (`mcr.microsoft.com/…`, `ghcr.io/…`,
  or a Docker Hub official library image with no user namespace) and carries a
  git-bearing tag (a full `-bookworm` / `-bullseye` base, an `mcr …/sdk` tag, or
  `buildpack-deps:<suite>-scm`). A sandbox runs `git clone` inside the image, so a
  `-slim` or `-alpine` tag breaks checkout before anything is built.
- Every `verify` entry names a `stage` and a `command`.
- A `when_present` is a relative path inside the checkout — not absolute, and not
  reaching outside with `..`.

## A command says what it needs to be present

`when_present` is the path a command needs to exist for it to run at all, resolved
under the context's workdir. A command with no `when_present` always runs.

One domain word covers repositories of different shapes, and a command is only ever
evidence about the shape it was measured on. Declaring it unconditionally reds a
clean repository that simply carries none of its files — and because the verify list
stops at the first failure, that false red HIDES every real gate behind it. So an
absent path SKIPS the command; it never fails it.

A path rather than a shape name: the taxonomy stays in the profile, where a new one
costs a file, instead of in the orchestrator, where it would cost a release.

## Rules the orchestrator applies

- **A declared `stack.image` wins.** The image named in the repository's own
  `context.yaml` is the image that gets used. The profile's image is reached only when
  the context names none. When the declared image is not the profile's and is not in
  `compatible_images`, the run says so and uses the declared image anyway.
- **A profile image that fails the gate refuses the run.** It is not dropped in favour of
  the language table — running the profile's commands in an image that never carried
  them is the failure this mechanism exists to prevent.
- **A repository's own build/test commands win over the profile's.** They were derived
  from the files; the profile is what applies when nothing was derived.
- **An unknown domain refuses the run before any sandbox is created**, naming the value,
  the repository and context that carried it, and the resolved catalog. A domain the
  pinned catalog does not carry is indistinguishable from a typo, so it is the same
  refusal.

## Versioning

A profile carries no version of its own. The catalog is versioned as a whole, and that
version is what a refusal names.
