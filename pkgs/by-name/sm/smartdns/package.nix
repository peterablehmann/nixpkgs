{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  testers,
  smartdns,
}:

stdenv.mkDerivation rec {
  pname = "smartdns";
  version = "46.1";

  src = fetchFromGitHub {
    owner = "pymumu";
    repo = "smartdns";
    rev = "Release${version}";
    hash = "sha256-IvaED1V1pP0/Qk2oND3fVr7PMXSnT9jFeuikEkndX0o=";
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSTEMDSYSTEMUNITDIR=${placeholder "out"}/lib/systemd/system"
    "RUNSTATEDIR=/run"
    # by default it is the build time... weird... https://github.com/pymumu/smartdns/search?q=ver
    "VER=${version}"
  ];

  installFlags = [ "SYSCONFDIR=${placeholder "out"}/etc" ];

  passthru.tests = {
    version = testers.testVersion {
      package = smartdns;
      command = "smartdns -v";
    };
  };

  meta = with lib; {
    description = "Local DNS server to obtain the fastest website IP for the best Internet experience";
    longDescription = ''
      SmartDNS is a local DNS server. SmartDNS accepts DNS query requests from local clients, obtains DNS query results from multiple upstream DNS servers, and returns the fastest access results to clients.
      Avoiding DNS pollution and improving network access speed, supports high-performance ad filtering.
      Unlike dnsmasq's all-servers, smartdns returns the fastest access resolution.
    '';
    homepage = "https://github.com/pymumu/smartdns";
    maintainers = [ maintainers.lexuge ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "smartdns";
  };
}
