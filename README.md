# yolov8-animeface-cli

yolov8-animeface-cli is a simple cli interface to [yolov8_animeface](https://github.com/Fuyucch1/yolov8_animeface/)

## Installation

Add the following input to your `flake.nix`
```nix
{
  inputs.yolov8-animeface-cli.url = "github:iynaix/yolov8-animeface-cli";
}
```
A [yolov8-animeface-cli cachix](https://yolov8-animeface-cli.cachix.org) is also available, providing prebuilt binaries. To use it, add the following to your configuration:
```nix
{
  nix.settings = {
    substituters = ["https://yolov8-animeface-cli.cachix.org"];
    trusted-public-keys = ["yolov8-animeface-cli.cachix.org-1:8Pfz5N6lVE9XevQD7P22cVpDoW8E3pdFNZkmHJyTPJY=
  };
}
```

Then, include it in your `environment.systemPackages` or `home.packages` by referencing the input:

```
inputs.yolov8-animeface-cli.packages.<system>.default
```

Alternatively, it can also be run directly:

```
nix run github:iynaix/yolov8-animeface-cli -- /path/to/image
```

## Usage

```console
$ anime-face-detector --help
usage: cli.py [-h] [--confidence CONFIDENCE] [--iou IOU] [--save] [--stream]
              PATHS [PATHS ...]

Anime face detection CLI.

positional arguments:
  PATHS                 Paths of directories or images to process

options:
  -h, --help            show this help message and exit
  --confidence CONFIDENCE
                        Confidence threshold for detection (e.g., 0.3).
  --iou IOU             Intersection over Union threshold for Non-Maximum
                        Suppression (e.g., 0.5).
  --save                Output images with detection boxes to ./runs
  --stream              Enable streaming prediction.
```

### Sample Output
```console
$ anime-face-detector --stream ~/Pictures/Wallpapers/image1.png ~/Pictures/Wallpapers/image2.png
{"/home/user/Pictures/Wallpapers/image1.png": [{"xmin":3213,"ymin":1197,"xmax":4567,"ymax":2576}]}
{"/home/user/Pictures/Wallpapers/image2.png": [{"xmin":1372,"ymin":418,"xmax":1801,"ymax":837}]}
```

## Hacking
Use `nix develop` for the default devenv.
