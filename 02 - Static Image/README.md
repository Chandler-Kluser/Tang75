# LESSON 2 - Pixel Matrix LED Driver with Tang Nano 9k

## Picture Generation

The Static Picture is converted to a ROM verilog header, which is wired to the framebuffer.

Use [Node.js](https://nodejs.org/) or [Python](https://www.python.org/) tools to generate high ROM and low ROM from your picture file.

It is recommended to use the `js` tool since it is more versatile and has more resources:

```bash
# picture is test2.png
make pic
```