{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "renovate";
  version = "37.87.0";

  src = fetchFromGitHub {
    owner = "renovatebot";
    repo = pname;
    rev = version;
    hash = "sha256-GL2i1L5a8lnO4it8pKqQzMoivRguwR4+hhh1exWisC4=";
  };

  npmDepsHash = "sha256-kD3Pe5lQyztC+mjF9juNojlUE45/tGFNrWRqpHNwWlw=";

  postPatch = ''
    cp ${./build_deps/package-lock.json} package-lock.json;
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Automated dependency updates. Multi-platform and multi-language.";
    homepage = "https://github.com/renovatebot/renovate";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ xgwq janik ];
  };
}
