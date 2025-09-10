import argparse
import os
from ultralytics import YOLO

def results_to_json(results):
    for result in results:
        for box in result.boxes.xyxy:
            box = box.round()

            yield {
                # "path": result.path,
                "xmin": int(box[0]),
                "ymin": int(box[1]),
                "xmax": int(box[2]),
                "ymax": int(box[3]),
            }

def parse_args():
    parser = argparse.ArgumentParser(description="Anime face detection CLI.")

    parser.add_argument(
        "--confidence",
        type=float,
        default=0.3,
        help="Confidence threshold for detection (e.g., 0.3).",
    )
    parser.add_argument(
        "--iou",
        type=float,
        default=0.5,
        help="Intersection over Union threshold for Non-Maximum Suppression (e.g., 0.5).",
    )
    parser.add_argument(
        "--save",
        action="store_true",
        help="Output images with detection boxes",
    )
    parser.add_argument(
        "--stream",
        action="store_true",
        help="Enable streaming prediction.",
    )
    parser.add_argument(
        "paths",
        type=str,
        nargs="+",
        metavar="PATHS",
        help="Paths of directories or images to process"
    )

    return parser.parse_args()

def main():
    args = parse_args()

    yolov8_animeface = YOLO(os.environ.get("MODEL_PATH"))
    for path in args.paths:
        for img in yolov8_animeface.predict(
            path,
            conf=args.confidence,
            iou=args.iou,
            # don't output progress as it is meant to be consumed by another script
            verbose=False,
            stream=True,
            save=args.save,
        ):
            print(list(results_to_json(img)))

if __name__ == "__main__":
    main()