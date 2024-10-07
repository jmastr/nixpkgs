{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, libxml2
, go
}:

buildGoModule rec {
  pname = "nordvpn";
  version = "3.19.0";
  gitHash = "644aca97c4292a2049efb38331f0bd36e3933d43";
  # MUST NOT be changed:
  # "Used to derive keys when encrypting/decrypting configuration files."
  # "Changing the Salt means changing the keys, which means losing access"
  # "to previously encrypted files. While this is fine during development,"
  # "production builds should never change the Salt between versions."
  salt = "ba4c5f597ab2c9d33c10c13abbe9d225";

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "nordvpn-linux";
    rev = "${version}";
    sha256 = "sha256-1JcAypF8X2mWbwXfp4JB7Tc5gTcT4mr3KOY74T1oSto=";
  };

  patches = [
    ./fix_could_not_determine_kind_of_name_for_c_free.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2
  ];

  vendorHash = "sha256-JEusJRr9AsCcTvJY+5W8HgY4/Hcs/ieNgysWqw1OY9Q=";

  CGO_CFLAGS = "-g -O2 -D_FORTIFY_SOURCE=2";
  CGO_LDFLAGS = "-Wl,-z,relro,-z,now";

  ldflags = [
    "-s" "-w" "-linkmode=external"
    # https://github.com/NordSecurity/nordvpn-linux/blob/3.19.0/BUILD.md?plain=1#L95-L100
    "-X main.Version=${version}"
    "-X main.Arch=${go.GOARCH}"
    "-X main.Environment=prod"
    "-X main.Hash=${gitHash}"
    "-X main.Salt=${salt}"
  ];

  subPackages = [
    "cmd/cli"
    "cmd/daemon"
    "cmd/norduser"
  ];

  installPhase = ''
    install -Dm755 /build/go/bin/cli $out/bin/nordvpn
    install -Dm755 /build/go/bin/daemon $out/bin/nordvpnd
    install -Dm755 /build/go/bin/norduser $out/bin/norduserd
  '';

  doCheck = false;

  meta = with lib; {
    description = "NordVPN Linux client";
    homepage = "https://nordvpn.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jmastr ];
    mainProgram = "nordvpn";
  };
}
