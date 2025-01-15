{
  description = "development environment for orb-slam3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

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

    # helper function to generate attrs for each system
    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
          inherit system;
        });

    # platform-specific configurations
    platformConfig = {
      pkgs,
      system,
    }: let
      isLinux = pkgs.stdenv.isLinux;
      isDarwin = pkgs.stdenv.isDarwin;
    in {
      # platform-specific build inputs
      buildInputs = with pkgs;
        [
          eigen
          opencv
          boost
          pangolin
          python3
          python3Packages.numpy
        ]
        ++ pkgs.lib.optionals isLinux [
          # linux-specific dependencies
          # rosPackages.melodic.ros-core
          # rosPackages.melodic.cv-bridge
        ];

      # platform-specific native build inputs
      nativeBuildInputs = with pkgs;
        [
          cmake
          pkg-config
        ]
        ++ pkgs.lib.optionals isDarwin [
          # Darwin-specific build tools
          # darwin.apple_sdk.frameworks.Cocoa
          # darwin.apple_sdk.frameworks.OpenGL
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
          chmod +x build.sh
          ./build.sh
        '';

        installPhase = ''
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
        buildInputs = with pkgs;
          [
            # development tools
            gcc
            cmake
            gnumake
            boost
            # valgrind
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            # linux-specific dependencies
            gdb
          ]
          ++ (platformConfig {inherit pkgs system;}).buildInputs;

        inherit (platformConfig {inherit pkgs system;}) nativeBuildInputs;

        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
            pkgs.eigen
            pkgs.opencv
            pkgs.pangolin
          ]}:$LD_LIBRARY_PATH
        '';
      };
    });
  };
}
