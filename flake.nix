{
  description = "development environment for orb-slam3";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
          inherit system;
        });

    platformConfig = {
      pkgs,
      system,
    }: let
      isLinux = pkgs.stdenv.isLinux;
      isDarwin = pkgs.stdenv.isDarwin;
    in {
      buildInputs = with pkgs;
        [
          gnumake
          opencv
          boost
          glew
          openssl
          eigen
          pangolin
          python3
          python3Packages.numpy
        ]
        ++ pkgs.lib.optionals isLinux [
        ];

      # platform-specific native build inputs
      nativeBuildInputs = with pkgs;
        [
          clang
          cmake
          pkg-config
          librealsense
          llvmPackages.openmp
        ]
        ++ pkgs.lib.optionals isDarwin [
        ];
    };
  in {
    packages = forAllSystems ({
      pkgs,
      system,
    }: {
      default = pkgs.stdenv.mkDerivation {
        pname = "orb-slam3";
        version = "0.13";
        src = ./.;
        inherit (platformConfig {inherit pkgs system;}) buildInputs nativeBuildInputs;
        buildPhase = ''
          # TODO: better scripting with just cmd runner
        '';
        installPhase = ''
          # TODO: make it platform independent
          mkdir -p $out/lib
          mkdir -p $out/bin
          cp lib/libORB_SLAM3.so $out/lib/
          cp Examples/*/* $out/bin/ || true
          cp -r Vocabulary $out/
        '';
        meta = with pkgs.lib; {
          description = "orb-slam3: an accurate open-source library for visual, visual-inertial and multi-map slam";
          homepage = "https://github.com/thuvasooriya/orb-slam3";
          license = licenses.mit;
          platforms = platforms.unix;
          maintainers = [thuvasooriya];
        };
      };
    });

    devShells = forAllSystems ({
      pkgs,
      system,
    }: {
      default = pkgs.mkShell {
        name = "os3-dev";
        buildInputs = with pkgs;
          [
            # development tools
            just
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
          ]
          ++ (platformConfig {inherit pkgs system;}).buildInputs;
        inherit (platformConfig {inherit pkgs system;}) nativeBuildInputs;
        # shellHook = ''
        # '';
      };
    });
  };
}
