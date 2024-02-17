import argparse
import json
import requests

def recognize_receipt(api_key, image_path, recognizer='auto', ref_no=None):
    url = "https://ocr.asprise.com/api/v1/receipt"

    files = {'file': open(image_path, 'rb')}
    data = {
        'api_key': api_key,
        'recognizer': recognizer,
        'ref_no': ref_no
    }

    response = requests.post(url, data=data, files=files)
    return json.loads(response.text)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Recognize receipt using Asprise OCR API")
    parser.add_argument("image_path", help="Path to the image file")
    parser.add_argument("--api_key", required=True, help="API key for the Asprise OCR API")
    parser.add_argument("--recognizer", default="auto", help="Type of recognizer (default: auto)")
    parser.add_argument("--ref_no", help="Reference number (optional)")

    args = parser.parse_args()

    response_data = recognize_receipt(args.api_key, args.image_path, args.recognizer, args.ref_no)

    with open("response.json", "w") as f:
        json.dump(response_data, f)
