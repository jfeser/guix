(define-module (feser sketch)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages java)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex))

(define-public sketch-binary
  (package
    (name "sketch")
    (version "1.7.6")
    (home-page "https://people.csail.mit.edu/asolar")
    (source
     (origin
       (method url-fetch)
       (uri (string-append home-page "/sketch-" version ".tar.gz"))
       (sha256 (base32 "01x75pkxlv74s1lscdd6w1nxzjrq3av8rbgrbwhk5m8zhk7cknjw"))))
    (build-system gnu-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'chdir-backend
           (lambda _ (chdir "sketch-backend")))

         (add-after 'install 'install-frontend
           (lambda* (#:key outputs #:allow-other-keys)
             (chdir "../sketch-frontend")
             (let* ((out (assoc-ref outputs "out")))
               (install-file "sketch" (string-append out "/bin"))
               (install-file (string-append "sketch-" ,version "-noarch.jar") (string-append out "/bin"))
               (copy-recursively "runtime" (string-append out "/share/sketch/runtime"))
               (copy-recursively "sketchlib" (string-append out "/share/sketch/sketchlib"))))))))
    (native-inputs
     (list bison flex))
    (inputs
     (list openjdk17))
    (search-paths
     (list (search-path-specification
            (variable "SKETCH_HOME")
            (files (list "share/sketch/runtime")))))
    (synopsis "Sketch is a tool for program synthesis by sketching")
    (description #f)
    (license license:expat)))
