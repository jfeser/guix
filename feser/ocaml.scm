(define-module (feser ocaml)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system dune)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages databases))

(define-public ocaml-intrinsics
  (package
    (name "ocaml-intrinsics")
    (version "0.15.2")
    (home-page "https://github.com/janestreet/ocaml_intrinsics")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1mazr1ka2zlm2s8bw5i555cnhi1bmr9yxvpn29d3v4m8lsnfm73z"))))
    (build-system dune-build-system)
    (arguments
     `(#:tests? #f))
    (propagated-inputs (list dune-configurator))
    (properties `((upstream-name . "ocaml_intrinsics")))
    (synopsis "Intrinsics")
    (description
     "Provides functions to invoke amd64 instructions (such as clz,popcnt,rdtsc,rdpmc)
      when available, or compatible software implementation on other targets.")
    (license license:expat)))

(define-public ocaml-sexp-pretty
  (package
    (name "ocaml-sexp-pretty")
    (version "0.15.0")
    (home-page "https://github.com/janestreet/sexp_pretty")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url home-page) (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256 (base32 "1p1jspwjvrhm8li22xl0n8wngs12d9g7nc1svk6xc32jralnxblg"))))
    (build-system dune-build-system)
    (propagated-inputs (list ocaml-base ocaml-ppx-base ocaml-sexplib ocaml-re))
    (properties `((upstream-name . "sexp_pretty")))
    (synopsis "S-expression pretty-printer")
    (description
     "A library for pretty-printing s-expressions, using better indentation rules
      than the default pretty printer in Sexplib.")
    (license license:expat)))

(define-public ocaml-expect-test-helpers-core
  (package
    (name "ocaml-expect-test-helpers-core")
    (version "0.15.0")
    (home-page "https://github.com/janestreet/expect_test_helpers_core")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bxs3g0zzym8agfcbpg5lmrh6hcb86z861bq40xhhfwqf4pzdbfa"))))
    (build-system dune-build-system)
    (propagated-inputs (list ocaml-base
                             ocaml-base-quickcheck
                             ocaml-core
                             ocaml-ppx-jane
                             ocaml-sexp-pretty
                             ocaml-stdio
                             ocaml-re))
    (properties `((upstream-name . "expect_test_helpers_core")))
    (synopsis "Helpers for writing expectation tests")
    (description
     "This library provides helper functions for writing expect tests.

If you want helpers for writing expect tests using the Async library, look at
expect_test_helpers_async.")
    (license license:expat)))

(define-public ocaml-core-unix
  (package
    (name "ocaml-core-unix")
    (version "0.15.0")
    (home-page "https://github.com/janestreet/core_unix")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1xzxqzg23in5ivz0v3qshzpr4w92laayscqj9im7jylh2ar1xi0a"))))
    (build-system dune-build-system)
    (arguments
     `(#:tests? #f))
    (propagated-inputs (list ocaml-core
                             ocaml-core-kernel
                             ocaml-expect-test-helpers-core
                             ocaml-jane-street-headers
                             ocaml-jst-config
                             ocaml-intrinsics
                             ocaml-ppx-jane
                             ocaml-sexplib
                             ocaml-timezone
                             ocaml-spawn
                             ocaml-sexp-pretty))
    (properties `((upstream-name . "core_unix")))
    (synopsis "Unix-specific portions of Core")
    (description
     "Unix-specific extensions to some of the modules defined in [core] and
[core_kernel].")
    (license license:expat)))

(define-public ocaml-pp
  (package
    (name "ocaml-pp")
    (version "1.1.2")
    (home-page "https://github.com/ocaml-dune/pp")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0w7gxa85ffbd6jgs6ziarq69yi423f0qkpk05r3abh6lg8smw8pg"))))
    (build-system dune-build-system)
    (native-inputs (list ocaml-ppx-expect))
    (synopsis "Pretty-printing library")
    (description
     "This library provides a lean alternative to the Format [1] module of the OCaml
standard library.  It aims to make it easy for users to do the right thing.  If
you have tried Format before but find its API complicated and difficult to use,
then Pp might be a good choice for you.

Pp uses the same concepts of boxes and break hints, and the final rendering is
done to formatter from the Format module.  However it defines its own algebra
which some might find easier to work with and reason about.  No previous
knowledge is required to start using this library, however the various guides
for the Format module such as this one [2] should be applicable to Pp as well.

[1]: https://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html [2]:
http://caml.inria.fr/resources/doc/guides/format.en.html")
    (license license:expat)))

(define-public ocaml-fiber
  (package
    (inherit dune)
    (name "ocaml-fiber")
    (build-system dune-build-system)
    (arguments
     `(#:package "fiber"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (propagated-inputs (list ocaml-stdune ocaml-dyn))
    (synopsis "Structured concurrency library")
    (description
     "This library offers no backwards compatibility guarantees.  Use at your own
risk.")))

(define-public ocaml-chrome-trace
  (package
    (inherit dune)
    (name "ocaml-chrome-trace")
    (build-system dune-build-system)
    (arguments
     `(#:package "chrome-trace"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (synopsis "Chrome trace event generation library")
    (description
     "This library offers no backwards compatibility guarantees.  Use at your own
risk.")))

(define-public ocaml-stdune
  (package
    (inherit dune)
    (name "ocaml-stdune")
    (build-system dune-build-system)
    (arguments
     `(#:package "stdune"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (propagated-inputs
     (list ocaml-dyn ocaml-ordering ocaml-pp ocaml-csexp))
    (synopsis "Dune's unstable standard library")
    (description
     "This library offers no backwards compatibility guarantees.  Use at your own
risk.")))

(define-public ocaml-xdg
  (package
    (inherit dune)
    (name "ocaml-xdg")
    (build-system dune-build-system)
    (arguments
     `(#:package "xdg" #:tests? #f))
    (synopsis "XDG Base Directory Specification")
    (description
     "https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html")
    (license license:expat)))

(define-public ocaml-dyn
  (package
    (inherit dune)
    (name "ocaml-dyn")
    (build-system dune-build-system)
    (arguments
     `(#:package "dyn"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (propagated-inputs (list ocaml-ordering ocaml-pp))
    (synopsis "Dynamic type")
    (description "Dynamic type")
    (license license:expat)))

(define-public ocaml-ordering
  (package
    (inherit dune)
    (name "ocaml-ordering")
    (build-system dune-build-system)
    (arguments
     `(#:package "ordering"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (synopsis "Element ordering")
    (description "Element ordering")
    (license license:expat)))

(define-public ocaml-dune-rpc
  (package
    (inherit dune)
    (name "ocaml-dune-rpc")
    (build-system dune-build-system)
    (arguments
     `(#:package "dune-rpc"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (propagated-inputs (list ocaml-csexp
                             ocaml-ordering
                             ocaml-dyn
                             ocaml-xdg
                             ocaml-stdune
                             ocaml-pp))
    (synopsis "Communicate with dune using rpc")
    (description "Library to connect and control a running dune instance")))

(define-public ocaml-pprint
  (package
    (name "ocaml-pprint")
    (version "20220103")
    (home-page "https://github.com/fpottier/pprint")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url home-page) (commit version)))
       (file-name (git-file-name name version))
       (sha256 (base32 "09y6nwnjldifm47406q1r9987njlk77g4ifqg6qs54dckhr64vax"))))
    (build-system dune-build-system)
    (synopsis "A pretty-printing combinator library and rendering engine")
    (description
     "This library offers a set of combinators for building so-called documents as
well as an efficient engine for converting documents to a textual, fixed-width
format.  The engine takes care of indentation and line breaks, while respecting
the constraints imposed by the structure of the document and by the text width.")
    (license #f)))

(define-public ocaml-sek
  (package
    (name "ocaml-sek")
    (version "20201012")
    (home-page "https://gitlab.inria.fr/fpottier/sek")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url home-page) (commit version)))
       (file-name (git-file-name name version))
       (sha256 (base32 "03hq1w0kf5jn2pilhsxd0hdfg45144p6my2760j2z6v2zab825xm"))))
    (build-system dune-build-system)
    (propagated-inputs (list ocaml-cppo ocaml-pprint ocaml-seq))
    (synopsis "An efficient implementation of ephemeral and persistent sequences")
    (description #f)
    (license license:lgpl3+)))

(define ocaml-ppx-yojson-conv-lib
  (package
    (name "ocaml-ppx-yojson-conv-lib")
    (version "0.15.0")
    (home-page "https://github.com/janestreet/ppx_yojson_conv_lib")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0slc5cwy60vx8gskmn20hmndjncpp5zs80a9wm7hxv8yl003i60y"))))
    (build-system dune-build-system)
    (arguments
     `(#:test-target "."))
    (propagated-inputs (list ocaml-yojson))
    (properties `((upstream-name . "ppx_yojson_conv_lib")))
    (synopsis "Runtime lib for ppx_yojson_conv")
    (description " Part of the Jane Street's PPX rewriters collection.")
    (license license:expat)))

(define-public ocaml-ppx-yojson-conv
  (package
    (name "ocaml-ppx-yojson-conv")
    (version "0.15.0")
    (home-page "https://github.com/janestreet/ppx_yojson_conv")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13vvcbmizsj849gkxswq7iyak65z2b2b03xb1wkx28qxp5w52sql"))))
    (build-system dune-build-system)
    (propagated-inputs (list ocaml-base
                             ocaml-ppx-js-style
                             ocaml-ppx-yojson-conv-lib
                             ocaml-ppxlib))
    (properties `((upstream-name . "ppx_yojson_conv")))
    (synopsis "[@@deriving] plugin to generate Yojson conversion functions")
    (description " Part of the Jane Street's PPX rewriters collection.")
    (license license:expat)))

(define-public ocaml-bheap
  (package
    (name "ocaml-bheap")
    (version "2.0.0")
    (home-page "https://github.com/backtracking/bheap")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0b8md5zl4yz7j62jz0bf7lwyl0pyqkxqx36ghkgkbkxb4zzggfj1"))))
    (build-system dune-build-system)
    (arguments
     `(#:tests? #f))
    (native-inputs (list ocaml-stdlib-shims))
    (synopsis "Priority queues")
    (description
     "Traditional implementation using a binary heap encoded in a resizable array")
    (license license:lgpl2.1)))

(define-public ocaml-iter
  (package
    (name "ocaml-iter")
    (version "1.5")
    (home-page "https://github.com/c-cube/iter/")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wyj8bi5y7r2dfp6lq187rcflh23c6i4lrn8bg6gnkpbaqy6mlr0"))))
    (build-system dune-build-system)
    (arguments
     `(#:tests? #f))
    (propagated-inputs (list ocaml-result ocaml-seq dune-configurator))
    (synopsis
     "Simple abstraction over `iter` functions, intended to iterate efficiently on
collections while performing some transformations")
    (description #f)
    (license #f)))


(define-public ocaml-omd
  (package
    (name "ocaml-omd")
    (version "1.3.2")
    (home-page "https://github.com/ocaml/omd")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0kn8c5647wflnrf8k5g22x2vfm2py8vy2iiflaqk8shxg2l1dq9x"))))
    (build-system dune-build-system)
    (arguments
     `(#:test-target "."))
    (synopsis "A Markdown frontend in pure OCaml")
    (description
     "This Markdown library is implemented using only pure OCaml (including I/O
operations provided by the standard OCaml compiler distribution).  OMD is meant
to be as faithful as possible to the original Markdown.  Additionally, OMD
implements a few Github markdown features, an extension mechanism, and some
other features.  Note that the opam package installs both the OMD library and
the command line tool `omd`.")
    (license license:isc)))

(define-public ocaml-lsp-server
  (package
    (name "ocaml-lsp-server")
    (version "1.12.4")
    (source
     (origin
       (method url-fetch)
       (uri "https://github.com/ocaml/ocaml-lsp/releases/download/1.12.4/lsp-1.12.4.tbz")
       (sha256 (base32 "0inqz433n79d78byh16dm370c5sdsb9i3ag8mffkammwgh19i6wi"))))
    (build-system dune-build-system)
    (arguments
     `(#:tests? #f))
    (propagated-inputs (list ocaml-yojson
                             ocaml-re
                             ocaml-ppx-yojson-conv-lib
                             ocaml-dune-rpc
                             ocaml-chrome-trace
                             ocaml-dyn
                             ocaml-stdune
                             ocaml-fiber
                             ocaml-xdg
                             ocaml-ordering
                             ocaml-dune-build-info
                             ocaml-spawn
                             ocaml-omd
                             ocaml-octavius
                             ocaml-uutf
                             ocaml-pp
                             ocaml-csexp
                             ocamlformat-rpc-lib))
    (properties `((upstream-name . "ocaml-lsp-server")))
    (home-page "https://github.com/ocaml/ocaml-lsp")
    (synopsis "LSP Server for OCaml")
    (description "An LSP server for OCaml.")
    (license license:isc)))

(define-public ocamlformat-rpc-lib
  (package
    (inherit ocamlformat)
    (name "ocamlformat-rpc-lib")
    (build-system dune-build-system)
    (arguments
     `(#:package "ocamlformat-rpc-lib"
       #:tests? #f))
    (propagated-inputs (list ocaml-csexp))
    (synopsis "Auto-formatter for OCaml code (RPC mode)")
    (description
     "OCamlFormat is a tool to automatically format OCaml code in a uniform style.
This package defines a RPC interface to OCamlFormat")))

(define-public ocaml-visitors
  (package
    (name "ocaml-visitors")
    (version "20210608")
    (source (origin
              (method url-fetch)
              (uri
               "https://gitlab.inria.fr/fpottier/visitors/-/archive/20210608/archive.tar.gz")
              (sha256
               (base32
                "1yx4bjw4yw3zi35yfp66x320xgb9f8jh7rqj1j7hrrvn0f60m2y2"))))
    (build-system dune-build-system)
    (propagated-inputs (list ocaml-ppxlib ocaml-ppx-deriving ocaml-result))
    (home-page "https://gitlab.inria.fr/fpottier/visitors")
    (synopsis "An OCaml syntax extension for generating visitor classes")
    (description
     "Annotating an algebraic data type definition with [@@deriving visitors { ... }]
causes visitor classes to be automatically generated.  A visitor is an object
that knows how to traverse and transform a data structure.")
    (license license:lgpl2.1)))

(define-public ocaml-postgresql
  (package
    (name "ocaml-postgresql")
    (version "5.0.0")
    (source (origin
              (method url-fetch)
              (uri
               "https://github.com/mmottl/postgresql-ocaml/releases/download/5.0.0/postgresql-5.0.0.tbz")
              (sha256
               (base32
                "1n7rgrh6z9jzs2wj1mjys0q0y8q7gy1v00jik631v0d4y9dl1kcw"))))
    (build-system dune-build-system)
    (arguments
     `(#:test-target "."))
    (propagated-inputs (list dune-configurator))
    (native-inputs (list postgresql))
    (home-page "https://mmottl.github.io/postgresql-ocaml")
    (synopsis "Bindings to the PostgreSQL library")
    (description
     "Postgresql offers library functions for accessing PostgreSQL databases.")
    (license #f)))

(define-public ocaml-sexp-diff
  (package
    (name "ocaml-sexp-diff")
    (version "0.15.0")
    (source (origin
              (method url-fetch)
              (uri
               "https://ocaml.janestreet.com/ocaml-core/v0.15/files/sexp_diff-v0.15.0.tar.gz")
              (sha256
               (base32
                "1q860bnbvmn5cnzbbi2ifspb0dilxgmy1j5p4yxiv0xhbp0dr55y"))))
    (build-system dune-build-system)
    (arguments
     `(#:test-target "."))
    (propagated-inputs (list ocaml-core ocaml-ppx-jane))
    (properties `((upstream-name . "sexp_diff")))
    (home-page "https://github.com/janestreet/sexp_diff")
    (synopsis "Code for computing the diff of two sexps")
    (description
     " The code behind the [diff] subcommand of the Jane Street's [sexp] command line
tool.")
    (license license:expat)))

(define ocaml-dune-private-libs
  (package
    (inherit dune)
    (name "ocaml-dune-private-libs")
    (build-system dune-build-system)
    (arguments
     `(#:package "dune-private-libs"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (propagated-inputs (list ocaml-csexp ocaml-pp ocaml-dyn ocaml-stdune))
    (synopsis "Private libraries of Dune")
    (description
     "!!!!!!!!!!!!!!!!!!!!!! !!!!! DO NOT USE !!!!! !!!!!!!!!!!!!!!!!!!!!!

This package contains code that is shared between various dune-xxx packages.
However, it is not meant for public consumption and provides no stability
guarantee.")))

(define-public ocaml-dune-site
  (package
    (inherit dune)
    (name "ocaml-dune-site")
    (build-system dune-build-system)
    (arguments
     `(#:package "dune-site"
                 #:tests? #f
                 #:phases
                 (modify-phases %standard-phases
                   ;; When building dune, these directories are normally removed after
                   ;; the bootstrap.
                   (add-before 'build 'remove-vendor
                     (lambda _
                       (delete-file-recursively "vendor/csexp")
                       (delete-file-recursively "vendor/pp"))))))
    (propagated-inputs (list ocaml-dune-private-libs))
    (synopsis "Embed locations informations inside executable and libraries")
    (description #f)))

(define-public ocaml-lwt-ppx
  (package
    (inherit ocaml-lwt)
    (name "ocaml-lwt-ppx")
    (version "2.1.0")
    (build-system dune-build-system)
    (arguments `(#:package "lwt_ppx"))
    (propagated-inputs (list ocaml-lwt ocaml-ppxlib))
    (properties `((upstream-name . "lwt_ppx")))
    (synopsis
     "PPX syntax for Lwt, providing something similar to async/await from JavaScript")
    (description #f)))

(define-public ocaml-textutils-kernel
  (package
    (name "ocaml-textutils-kernel")
    (version "0.15.0")
    (source (origin
              (method url-fetch)
              (uri
               "https://ocaml.janestreet.com/ocaml-core/v0.15/files/textutils_kernel-v0.15.0.tar.gz")
              (sha256
               (base32
                "0dzsazmwnjq11z533wq3a319drlgrjgxr28y2j40h2i4qdfr3b5c"))))
    (build-system dune-build-system)
    (arguments
     `(#:test-target "."))
    (propagated-inputs (list ocaml-core ocaml-ppx-jane ocaml-uutf))
    (properties `((upstream-name . "textutils_kernel")))
    (home-page "https://github.com/janestreet/textutils_kernel")
    (synopsis "Text output utilities")
    (description "")
    (license license:expat)))

(define-public ocaml-textutils
  (package
    (name "ocaml-textutils")
    (version "0.15.0")
    (source (origin
              (method url-fetch)
              (uri
               "https://ocaml.janestreet.com/ocaml-core/v0.15/files/textutils-v0.15.0.tar.gz")
              (sha256
               (base32
                "1pr2vhvmiqcdipwd21vif24p2zzv6kbhvcmzkzb7qwhqmnv8ydn0"))))
    (build-system dune-build-system)
    (arguments
     `(#:test-target "."))
    (propagated-inputs (list ocaml-core
                             ocaml-core-kernel
                             ocaml-core-unix
                             ocaml-ppx-jane
                             ocaml-textutils-kernel
                             ocaml-uutf))
    (home-page "https://github.com/janestreet/textutils")
    (synopsis "Text output utilities")
    (description "")
    (license license:expat)))

(define-public ocaml-core-bench
  (package
    (name "ocaml-core-bench")
    (version "0.15.0")
    (source (origin
              (method url-fetch)
              (uri
               "https://ocaml.janestreet.com/ocaml-core/v0.15/files/core_bench-v0.15.0.tar.gz")
              (sha256
               (base32
                "0n2jaf62l7i5k48rm1z1kihypaq1qz3dyplda8fvmw1mbgkn9csx"))))
    (build-system dune-build-system)
    (propagated-inputs (list ocaml-core
                             ocaml-core-kernel
                             ocaml-core-unix
                             ocaml-ppx-compare
                             ocaml-ppx-fields-conv
                             ocaml-ppx-jane
                             ocaml-ppx-let
                             ocaml-ppx-sexp-conv
                             ocaml-textutils
                             ocaml-re))
    (properties `((upstream-name . "core_bench")))
    (home-page "https://github.com/janestreet/core_bench")
    (synopsis "Benchmarking library")
    (description "")
    (license license:expat)))
