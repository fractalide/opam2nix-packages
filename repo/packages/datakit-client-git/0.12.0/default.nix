world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      alcotest = opamSelection.alcotest or null;
      datakit-client = opamSelection.datakit-client;
      git-unix = opamSelection.git-unix;
      irmin-git = opamSelection.irmin-git;
      irmin-mem = opamSelection.irmin-mem or null;
      irmin-watcher = opamSelection.irmin-watcher;
      jbuilder = opamSelection.jbuilder;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "datakit-client-git-0.12.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "datakit-client-git";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1lbm38x6fsiakzswmv4y781ncmigd8yrla2dj1glwqn7mizm2gqg";
    url = "https://github.com/moby/datakit/releases/download/0.12.0/datakit-0.12.0.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

