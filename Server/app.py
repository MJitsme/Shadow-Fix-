import flask
from flask import Flask, request, jsonify
import base64
import numpy as np

# Assuming model and argument functions are in separate files
from model_lgsn import Generator_S2F

def process_image(image_bytes):
    """
    Processes an image using the shadow removal model and returns the base64 encoded output.

    Args:
        image_bytes: Byte array representing the image data.

    Returns:
        str: Base64 encoded string of the processed image data, or None on error.
    """

    try:
        # Load image
        image = io.imread(io.BytesIO(image_bytes))

        # Convert to Lab color space
        labimage = color.rgb2lab(image)

        # Get arguments (replace with actual argument parsing)
	  generator_A2B = "path"

        # Preprocess image for model input
        labimage448 = resize(labimage, (448, 448, 3))
        labimage_L448 = labimage448[:, :, 0]

        # Normalize and convert to tensor
        labimage448[:, :, 0] = (labimage448[:, :, 0] / 50.0) - 1.0
        labimage448[:, :, 1:] = 2.0 * ((labimage448[:, :, 1:] + 128.0) / 255.0) - 1.0
        labimage448 = torch.from_numpy(labimage448).float()
        labimage_L448 = torch.from_numpy(labimage_L448.reshape((448, 448, 1))).float()

        # Load and process with the model (replace with actual model loading and execution)
        model = Generator_S2F()
        model.load_state_dict(torch.load(generator_A2B))
        model.eval()
        with torch.no_grad():
            if args.cuda and torch.cuda.is_available():
                model.to(torch.device('cuda'))
                labimage448 = labimage448.to(torch.device('cuda'))
                labimage_L448 = labimage_L448.to(torch.device('cuda'))
            temp_B448, _ = model(labimage448, labimage_L448)

        # Post-process and convert to RGB
        fake_B448 = temp_B448.data.cpu().squeeze(0).permute(1, 2, 0).numpy()
        fake_B448[:, :, 0] = (fake_B448[:, :, 0] + 1.0) * 50.0
        fake_B448[:, :, 1:] = (fake_B448[:, :, 1:] + 1.0) * 255.0 / 2.0 - 128.0
        fake_B448 = resize(fake_B448, (480, 640, 3))
        outputimage = color.lab2rgb(fake_B448)

        # Encode to base64 string
        return b64encode(outputimage.tobytes()).decode('utf-8')

    except Exception as e:
        print(f"Error processing image: {e}")
        return None  # Return None on error

app = Flask(name)

@app.route('/process_image', methods=['POST'])
def process_image_from_base64():
    data = request.get_json()

    if 'base64_image' not in data:
        return jsonify({'error': 'Missing base64_image in request data'}), 400

    image_bytes = base64.b64decode(data['base64_image'])
    processed_image = process_image(image_bytes)

    if processed_image is None:
        return jsonify({'error': 'Error processing image'}), 50

    return jsonify({'processed_image': processed_image}),200    
if name == 'main':
    app.run()
