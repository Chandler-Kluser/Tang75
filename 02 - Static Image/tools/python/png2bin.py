from PIL import Image

# Open the .png image
image = Image.open("../src/yt_count.png")
image = image.convert("RGB", dither=Image.NONE)  # Disable dithering
image = image.quantize(colors=3, method=2)  # Convert to 8 colors

# Get the pixel data as a list of integers
pixel_data = list(image.getdata())

# Convert the pixel data to binary format
binary_data = bytearray(pixel_data)

# Write the binary data to a binary file
with open("../src/image.bin", "wb") as f:
    f.write(binary_data)

print("ready")
