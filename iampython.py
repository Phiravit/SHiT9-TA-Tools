from PIL import Image
import numpy as np
import argparse

def generate_recursive_mosaic(image: Image.Image, tile_size: int = 10, depth: int = 1) -> Image.Image:
    if depth < 1:
        return image
    small = image.resize((image.width // tile_size, image.height // tile_size), Image.Resampling.LANCZOS)
    small_array = np.array(small)
    mosaic = Image.new("RGB", (small.width * tile_size, small.height * tile_size))
    for y in range(small.height):
        for x in range(small.width):
            pixel_color = small_array[y, x]
            mini = image.resize((tile_size, tile_size), Image.Resampling.LANCZOS)
            mini_np = np.array(mini).astype(np.float32)
            blended = (mini_np * 0.3 + pixel_color * 0.7).clip(0, 255).astype(np.uint8)
            blended_img = Image.fromarray(blended)
            mosaic.paste(blended_img, (x * tile_size, y * tile_size))
    return generate_recursive_mosaic(mosaic, tile_size, depth - 1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("input", help="Input image path")
    parser.add_argument("output", help="Output mosaic path")
    parser.add_argument("--tile", type=int, default=10, help="Tile size")
    parser.add_argument("--depth", type=int, default=1, help="Recursion depth")
    args = parser.parse_args()

    image = Image.open(args.input).convert("RGB")
    mosaic = generate_recursive_mosaic(image, args.tile, args.depth)
    mosaic.save(args.output)