{
  lib,
  python3Packages,
  anime-face-model,
  cudaSupport ? false,
  rocmSupport ? false,
}:
assert !(cudaSupport && rocmSupport);
python3Packages.buildPythonApplication {
  pname = "anime-face-detector";
  version = "1.0.0";
  pyproject = true;

  src = ./.;

  postPatch = ''
    substituteInPlace cli.py \
      --replace 'os.environ.get("MODEL_PATH")' '"${anime-face-model}"'
  ''
  + lib.optionalString (cudaSupport || rocmSupport) ''
    substituteInPlace cli.py \
      --replace 'device = "cpu"' 'device = "cuda:0"'
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
