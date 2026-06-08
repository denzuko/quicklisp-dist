# denzuko/quicklisp-dist

Self-hosted [Quicklisp](https://www.quicklisp.org/) distribution for
Common Lisp packages maintained by Dwight Spencer / Da Planet Security.

## Packages

| System | Description | Repo |
|---|---|---|
| `mlisp` | Minimalist mailing list manager (smartlist replacement) | [denzuko/mlisp](https://github.com/denzuko/mlisp) |
| `mlisp-test` | FiveAM test suite for mlisp | [denzuko/mlisp](https://github.com/denzuko/mlisp) |

## Layout

```
quicklisp-dist/
  packages/
    mlisp/            ← git submodule → github.com/denzuko/mlisp
      mlisp.asd
      mlisp-test.asd
      src/
      test/
    <future-package>/ ← git submodule → github.com/denzuko/<pkg>
  distinfo.txt        ← Quicklisp dist descriptor
  releases.txt        ← one line per package release
  systems.txt         ← one line per ASDF system
  Makefile            ← regenerate metadata from submodules
```

## Adding a new package

```sh
# 1. Add submodule
git submodule add https://github.com/denzuko/<pkg>.git packages/<pkg>

# 2. Regenerate dist metadata
make dist

# 3. Commit
git add packages/<pkg> distinfo.txt releases.txt systems.txt
git commit -m "feat: add <pkg> to dist"
```

## Using this dist

```lisp
;; In your Lisp init or project:
(ql-dist:install-dist
  "https://raw.githubusercontent.com/denzuko/quicklisp-dist/main/distinfo.txt"
  :prompt nil)

;; Then:
(ql:quickload :mlisp)
```

Or for local development (no network):

```lisp
(push "/path/to/quicklisp-dist/packages/mlisp/" asdf:*central-registry*)
(asdf:load-system :mlisp)
```

## Dist metadata format

`distinfo.txt` — Quicklisp dist descriptor:
```
name: denzuko
version: 2026-06-08
system-index-url: https://raw.githubusercontent.com/denzuko/quicklisp-dist/main/systems.txt
release-index-url: https://raw.githubusercontent.com/denzuko/quicklisp-dist/main/releases.txt
archive-base-url: https://github.com/denzuko/
canonical-distinfo-url: https://raw.githubusercontent.com/denzuko/quicklisp-dist/main/distinfo.txt
```

`systems.txt` — one line per ASDF system:
```
<release-name> <system-file-path-relative-to-release> <system-name> [dependencies...]
```

`releases.txt` — one line per release tarball:
```
<project-name> <url> <size> <md5> <sha1> <prefix> [files...]
```

## License

Individual packages retain their own licenses. See each submodule.
This dist metadata is CC0.
