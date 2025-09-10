{
  lib,
  python3Packages,
  anime-face-model,
}:
python3Packages.buildPythonApplication {
  pname = "anime-face-detector";
  version = "1.0.0";
  pyproject = true;

  src = ./.;

  postPatch = ''
    substituteInPlace cli.py \
      --replace 'os.environ.get("MODEL_PATH")' '"${anime-face-model}"'
  '';

  buildSystem = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    ultralytics
  ];

  meta = with lib; {
    description = "CLI for Fuyucch1/yolov8_animeface";
    homepage = "https://github.com/iynaix/anime-face-detector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "anime-face-detector";
  };
}
