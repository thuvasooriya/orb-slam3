{
  description = "Flake to build DBoW2 with OpenCV";

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux; # Adjust system if necessary
  in {
    packages.default = pkgs.stdenv.mkDerivation {
      pname = "DBoW2";
      version = "1.0";

      src = ./.;

      nativeBuildInputs = [
        pkgs.cmake
        pkgs.opencv4
      ];

      buildInputs = [
        pkgs.opencv4
      ];

      cmakeFlags = [
        "-DCMAKE_BUILD_TYPE=Release"
      ];

      buildPhase = ''
        cmake . ${cmakeFlags}
        make
      '';

      installPhase = ''
        mkdir -p $out/lib $out/include/DBoW2 $out/include/DUtils
        cp lib/libDBoW2.so $out/lib/
        cp DBoW2/*.h $out/include/DBoW2/
        cp DUtils/*.h $out/include/DUtils/
      '';

      meta = with pkgs.lib; {
        description = "DBoW2 Library with OpenCV";
        homepage = "https://github.com/your-repo-url"; # Replace with your project URL
        license = licenses.mit; # Update with actual license
        maintainers = [maintainers.yourGitHubUsername];
      };
    };
  };
}
