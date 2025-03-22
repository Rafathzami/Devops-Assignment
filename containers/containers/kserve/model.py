#model.py


import io
import time
import base64
from typing import Dict
from PIL import Image
import pytesseract
import kserve
from kserve import Model, ModelServer, InferRequest, InferResponse, InferInput, InferOutput
from kserve.utils.utils import generate_uuid
from prometheus_client import start_http_server, Counter, Histogram, Gauge

class OCRModel(Model):
    def __init__(self, name: str):
        super().__init__(name)
        self.name = name
        self.ready = True  # Model is ready to serve

        self.inference_requests_total = Counter(
            "ocr_inference_requests_total", "Total number of OCR inference requests"
        )
        self.inference_failures_total = Counter(
            "ocr_inference_failures_total", "Total number of failed OCR inference requests"
        )
        self.inference_duration_seconds = Histogram(
            "ocr_inference_duration_seconds", "Histogram of OCR inference durations"
        )
        self.inference_successful = Gauge(
            "ocr_inference_successful", "OCR inference success status"
        )

    async def predict(self, infer_request: InferRequest, headers: Dict[str, str] = None) -> InferResponse:
        start_time = time.time()  # Start timing inference
        try:
            # Increment inference requests counter
            self.inference_requests_total.inc()

            # Extract the binary image data from the inference request
            input_tensor = infer_request.inputs[0]
            base64_image_data = input_tensor.data[0]  # Base64 encoded string

            # Decode base64 string to bytes
            image_data = base64.b64decode(base64_image_data)

            # Open the image using PIL
            image = Image.open(io.BytesIO(image_data))

            # Use Tesseract to extract text from the image
            extracted_text = pytesseract.image_to_string(image)

            # Prepare the inference response
            response_id = generate_uuid()
            output = InferOutput(
                name="output-0",
                shape=[1],
                datatype="BYTES",
                data=extracted_text,  # Output is the text extracted by OCR
            )
            infer_response = InferResponse(
                model_name=self.name,
                infer_outputs=[output],
                response_id=response_id
            )

            # Track successful inference
            self.inference_successful.set(1)
            return infer_response
        except Exception as e:
            self.inference_failures_total.inc()
            self.inference_successful.set(0)
            raise e
        finally:
            duration = time.time() - start_time
            self.inference_duration_seconds.observe(duration)


if __name__ == "__main__":  
    start_http_server(8000)  
    model = OCRModel("ocr-model")
    ModelServer().start([model])
