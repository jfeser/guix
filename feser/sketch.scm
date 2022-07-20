(define-module (feser sketch)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages java)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex))

(define-public sketch
  (package
    (name "sketch")
    (version "1.7.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://people.csail.mit.edu/asolar/sketch-" version ".tar.gz"))
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
               (install-file "sketch" (string-append out "/share/sketch"))
               (install-file (string-append "sketch-" ,version "-noarch.jar") (string-append out "/share/sketch"))
               (copy-recursively "runtime" (string-append out "/share/sketch/runtime"))
               (copy-recursively "sketchlib" (string-append out "/share/sketch/sketchlib"))))))))
    (native-inputs
     (list bison flex))
    (inputs
     (list openjdk17))
    (synopsis "Hello, Guix world: An example custom Guix package")
    (description
     "GNU Hello prints the message \"Hello, world!\" and then exits.  It
serves as an example of standard GNU coding practices.  As such, it supports
command-line arguments, multiple languages, and so on.")
    (home-page "https://www.gnu.org/software/hello/")
    (license license:expat)))
