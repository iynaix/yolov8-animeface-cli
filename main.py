from ultralytics import YOLO

def results_to_json(results):
    """Convert YOLO results to JSON format"""
    for result in results:
        for box in result.boxes.xyxy:
            box = box.round()

            yield {
                "xmin": int(box[0]),
                "ymin": int(box[1]),
                "xmax": int(box[2]),
                "ymax": int(box[3]),
            }


yolov8_animeface = YOLO("yolov8x6_animeface.pt")
for img in yolov8_animeface.predict(
    "/home/iynaix/Pictures/wallpapers_in",
    save=True,
    conf=0.3,
    iou=0.5,
    verbose=False,
    stream=True,
):
    print(img.path)
    print(list(results_to_json(img)))
