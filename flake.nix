{
  description = "FSQ library in OCaml";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    # flake-utils.url = "github:numtide/flake-utils";

    # fsq-src = {
    #   url = github:p2pcollab/ocaml-fsq;
    #   flake = false;
    # };
  };
  
  outputs = { self, nixpkgs, flake-utils }:
    let
      # Generate a user-friendly version numer.
      # version = builtins.substring 0 8 fsq-src.lastModifiedDate;
      
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      
      supportedOcamlPackages = [
        "ocamlPackages_4_10"
        "ocamlPackages_4_11"
        "ocamlPackages_4_12"
        "ocamlPackages_4_13"
      ];
      defaultOcamlPackages = "ocamlPackages_4_13";

      forAllOcamlPackages = nixpkgs.lib.genAttrs (supportedOcamlPackages ++ [ "ocamlPackages" ]);
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      
      nixpkgsFor =
        forAllSystems (system:
          import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          });
    in {
        overlays.default = final: prev:
          with final;
          let mkOcamlPackages = prevOcamlPackages:
                with prevOcamlPackages;
                let ocamlPackages = {
                      inherit ocaml;
                      inherit findlib;
                      inherit ocamlbuild;
                      inherit opam-file-format;
                      inherit buildDunePackage;
                      inherit version;
                      name = "ocaml-packages";

                      fsq = buildDunePackage rec {
                        # inherit version;
                        minimumOCamlVersion = "4.10";
                        enableParallelBuilding = true;
                        pname = "fsq";
                        version = "0.0.1";
                        src = self;

                        useDune2 = true;
                        doCheck = true;
                        
                        nativeBuildInputs = with ocamlPackages; [ odoc ];

                        propagatedBuildInputs = with ocamlPackages; [
                          psq
                        ];
                        
                        checkInputs = [
                          psq
                          ounit
                        ];

                        meta = with lib; {
                          homepage = "https://github.com/p2pcollab/ocaml-fsq";
                          description = "FSQ is an OCaml implementation of functional fixed-size search queues, where old elements get popped from the queue when pushing to a queue that reached its maximum size.";
                          license = licenses.mpl20;
                        };
                      };
                    };
                in ocamlPackages;
          in
            let allOcamlPackages =
                  forAllOcamlPackages (ocamlPackages:
                    mkOcamlPackages ocaml-ng.${ocamlPackages});
            in
              allOcamlPackages // {
                ocamlPackages = allOcamlPackages.${defaultOcamlPackages};
              };

        packages = 
          forAllSystems (system:
            forAllOcamlPackages (ocamlPackages:
              nixpkgsFor.${system}.${ocamlPackages}));

        defaultPackage =
          forAllSystems (system:
            nixpkgsFor.${system}.ocamlPackages.fsq);
      };
}
