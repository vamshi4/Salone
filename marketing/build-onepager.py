"""Build a self-contained one-pager: inline every screenshot as a data URI.

The template references ../brand/screenshots/*.png, which only resolves when the
file is opened from this folder. Inlining makes the HTML portable — it renders
identically from any path, any browser, and any PDF tool.

    python build-onepager.py        # writes chairful-one-pager.built.html
"""
import base64
import io
import pathlib
import re

from PIL import Image

HERE = pathlib.Path(__file__).parent
TEMPLATE = HERE / "chairful-one-pager.html"
OUTPUT = HERE / "chairful-one-pager.built.html"

# The shots render 48mm wide x 82mm tall (object-fit: cover, anchored top).
# At ~300dpi that is 600x1025, so pre-crop to exactly that and skip the
# browser doing it for us.
SHOT_W = 600
SHOT_H = 1025


def data_uri(path: pathlib.Path) -> str:
    with Image.open(path) as im:
        im = im.convert("RGB")
        scaled = im.resize((SHOT_W, round(im.height * SHOT_W / im.width)), Image.LANCZOS)
        cropped = scaled.crop((0, 0, SHOT_W, min(SHOT_H, scaled.height)))
        buf = io.BytesIO()
        cropped.save(buf, format="PNG", optimize=True)
    encoded = base64.b64encode(buf.getvalue()).decode("ascii")
    return f"data:image/png;base64,{encoded}"


def main() -> None:
    html = TEMPLATE.read_text(encoding="utf-8")

    def replace(match: re.Match) -> str:
        rel = match.group(1)
        path = (HERE / rel).resolve()
        if not path.exists():
            raise FileNotFoundError(f"Missing screenshot: {path}")
        uri = data_uri(path)
        print(f"  inlined {path.name}  ({len(uri) // 1024} KB base64)")
        return f'src="{uri}"'

    built = re.sub(r'src="([^"]+\.png)"', replace, html)
    OUTPUT.write_text(built, encoding="utf-8")
    kb = OUTPUT.stat().st_size // 1024
    print(f"wrote {OUTPUT.name} ({kb} KB, self-contained)")


if __name__ == "__main__":
    main()
