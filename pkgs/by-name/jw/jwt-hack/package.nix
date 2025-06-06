{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jwt-hack";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "jwt-hack";
    tag = "v${version}";
    hash = "sha256-IHR+ItI4ToINLpkVc7yrgpNTS17nD02G6x3pNMEfIW4=";
  };

  vendorHash = "sha256-YEH+epSvyy1j0s8AIJ5+BdF47H7KqgBRC4t81noOkjo=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Tool for attacking JWT";
    homepage = "https://github.com/hahwul/jwt-hack";
    changelog = "https://github.com/hahwul/jwt-hack/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jwt-hack";
  };
}
