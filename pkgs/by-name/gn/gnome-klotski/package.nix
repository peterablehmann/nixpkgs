{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  vala,
  gnome,
  adwaita-icon-theme,
  gtk3,
  wrapGAppsHook3,
  appstream-glib,
  desktop-file-utils,
  glib,
  librsvg,
  libxml2,
  gettext,
  itstool,
  libgee,
  libgnome-games-support,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-klotski";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-klotski/${lib.versions.majorMinor version}/gnome-klotski-${version}.tar.xz";
    hash = "sha256-kWN4RWSfPKcJ0p9x7ndblG0REghyCfMiZOj60hoMoOI=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    meson
    ninja
    python3
    wrapGAppsHook3
    gettext
    itstool
    libxml2
    appstream-glib
    desktop-file-utils
    adwaita-icon-theme
  ];

  buildInputs = [
    glib
    gtk3
    librsvg
    libgee
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-klotski"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-klotski";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-klotski/-/blob/${version}/NEWS?ref_type=tags";
    description = "Slide blocks to solve the puzzle";
    mainProgram = "gnome-klotski";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
