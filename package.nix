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

  dependencies =
    let
      ps = python3Packages;
      ultralytics' =
        if cudaSupport then
          [
            (ps.ultralytics.override {
              torch = ps.torchWithCuda;
              torchvision = ps.torchvision.override { torch = ps.torchWithCuda; };
              ultralytics-thop = ps.ultralytics-thop.override { torch = ps.torchWithCuda; };
            })
          ]
        else if rocmSupport then
          [
            (ps.ultralytics.override {
              torch = ps.torchWithRocm;
              torchvision = ps.torchvision.override { torch = ps.torchWithRocm; };
              ultralytics-thop = ps.ultralytics-thop.override { torch = ps.torchWithRocm; };
            })
          ]
        else
          [
            ps.ultralytics
          ];
    in
    [ ultralytics' ];

  meta = with lib; {
    description = "CLI for Fuyucch1/yolov8_animeface";
    homepage = "https://github.com/iynaix/anime-face-detector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "anime-face-detector";
  };
}
