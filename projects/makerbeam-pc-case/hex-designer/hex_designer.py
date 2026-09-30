# generated using AI assitance

import tkinter as tk
from tkinter import filedialog, messagebox
import math
import ast

# ==========================================
# OpenSCAD Parameters (Identical to your .scad)
# ==========================================
COLS = 27   # _x_cnt
ROWS = 43   # _y_cnt

MB_COVER_PATTERN_D = 8.4
MB_COVER_PATTERN_SPACING = 1.6  # Spacing in mm

# Exact OpenSCAD geometry math:
_a = MB_COVER_PATTERN_D + MB_COVER_PATTERN_SPACING
_tiling_a = math.sqrt(0.75 * _a * _a)
_x_off_scad = _tiling_a
_y_off_scad = _tiling_a * math.sin(math.radians(120))

# Display scale (pixels per mm)
SCALE = 2.15
DX = _x_off_scad * SCALE
DY = _y_off_scad * SCALE
HEX_R = (MB_COVER_PATTERN_D / 2.0) * SCALE

# Theme: Full Lime Green Panel + Black Engraved Holes
COLOR_LIME_THEME = "#6fd61f"     # Vibrant Lime panel background
COLOR_CANVAS_BG = "#74e022"      # Canvas plate background
COLOR_HEX_SOLID = "#74e022"      # 1 = Turned off / Solid accent (matches lime plate)
COLOR_OUTLINE_SOLID = "#4ea80f"  # Visible seam for solid hexes
COLOR_HEX_HOLE = "#111111"       # 0 = Cut hole (Black baseline)
COLOR_OUTLINE_HOLE = "#000000"

class HexGridDesigner:
    def __init__(self, root):
        self.root = root
        self.root.title("OpenSCAD Hex Pattern Designer")
        self.root.configure(bg=COLOR_LIME_THEME)

        self.margin_x = 35
        self.margin_y = 35

        canvas_w = int(COLS * DX + DX + self.margin_x * 2)
        canvas_h = int(ROWS * DY + HEX_R * 2 + self.margin_y * 2)

        # 0 = hole cut (black), 1 = turned off (lime green solid)
        self.grid = [[0 for _ in range(COLS)] for _ in range(ROWS)]
        self.hex_items = {}
        self.current_brush = 1

        # --- Top Toolbar (Dark buttons for high contrast against lime) ---
        toolbar = tk.Frame(root, bg=COLOR_LIME_THEME, pady=8)
        toolbar.pack(side=tk.TOP, fill=tk.X)

        btn_style = {
            "bg": "#1e1e1e",
            "fg": "#ffffff",
            "activebackground": "#333333",
            "activeforeground": "#74e022",
            "relief": tk.RAISED,
            "bd": 1,
            "font": ("Arial", 9, "bold")
        }

        tk.Button(toolbar, text="Export pattern_array", command=self.export_scad, **btn_style).pack(side=tk.LEFT, padx=6)
        tk.Button(toolbar, text="Load .scad", command=self.load_scad, **btn_style).pack(side=tk.LEFT, padx=4)
        tk.Button(toolbar, text="All Lime (No Holes)", command=self.fill_lime, **btn_style).pack(side=tk.LEFT, padx=4)
        tk.Button(toolbar, text="All Holes (Black)", command=self.fill_holes, **btn_style).pack(side=tk.LEFT, padx=4)
        tk.Button(toolbar, text="Invert", command=self.invert_all, **btn_style).pack(side=tk.LEFT, padx=4)

        self.status_lbl = tk.Label(toolbar, text="", bg=COLOR_LIME_THEME, fg="#112205", font=("Arial", 10, "bold"))
        self.status_lbl.pack(side=tk.RIGHT, padx=12)

        # --- Canvas with Scrollbars ---
        frame = tk.Frame(root, bg=COLOR_LIME_THEME)
        frame.pack(fill=tk.BOTH, expand=True)

        self.canvas = tk.Canvas(frame, bg=COLOR_CANVAS_BG, highlightthickness=0,
                                scrollregion=(0, 0, canvas_w, canvas_h))
        vbar = tk.Scrollbar(frame, orient=tk.VERTICAL, command=self.canvas.yview)
        hbar = tk.Scrollbar(frame, orient=tk.HORIZONTAL, command=self.canvas.xview)
        self.canvas.configure(xscrollcommand=hbar.set, yscrollcommand=vbar.set)

        vbar.pack(side=tk.RIGHT, fill=tk.Y)
        hbar.pack(side=tk.BOTTOM, fill=tk.X)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

        self.draw_grid()
        self.update_status()

        # Mouse painting (drag-to-paint)
        self.canvas.bind("<Button-1>", self.on_press)
        self.canvas.bind("<B1-Motion>", self.on_drag)

    def get_hex_points(self, cx, cy, r):
        # OpenSCAD: rotate([0,0,90]) cylinder($fn=6) => Pointy-top hex
        pts = []
        for i in range(6):
            angle = math.radians(90 + 60 * i)
            pts.append(cx + r * math.cos(angle))
            pts.append(cy + r * math.sin(angle))
        return pts

    def draw_grid(self):
        self.canvas.delete("all")
        self.hex_items.clear()

        for y in range(ROWS):
            # y=0 is bottom in OpenSCAD => visually rendered at the bottom
            cy = self.margin_y + (ROWS - 1 - y) * DY

            # __x_off = y % 2 == 0 ? -_tiling_a/2 : 0;
            # Relative to even rows, odd rows are shifted right by +DX/2
            x_shift = 0.0 if (y % 2 == 0) else (DX / 2.0)

            for x in range(COLS):
                cx = self.margin_x + x * DX + x_shift
                pts = self.get_hex_points(cx, cy, HEX_R)

                state = self.grid[y][x]
                color = COLOR_HEX_SOLID if state == 1 else COLOR_HEX_HOLE
                outline = COLOR_OUTLINE_SOLID if state == 1 else COLOR_OUTLINE_HOLE

                item_id = self.canvas.create_polygon(pts, fill=color, outline=outline, width=1)
                self.hex_items[item_id] = (y, x)
                self.canvas.addtag_withtag(f"hex_{y}_{x}", item_id)

    def set_hex(self, y, x, state):
        if self.grid[y][x] != state:
            self.grid[y][x] = state
            color = COLOR_HEX_SOLID if state == 1 else COLOR_HEX_HOLE
            outline = COLOR_OUTLINE_SOLID if state == 1 else COLOR_OUTLINE_HOLE

            item_id = self.canvas.find_withtag(f"hex_{y}_{x}")
            if item_id:
                self.canvas.itemconfig(item_id[0], fill=color, outline=outline)

    def on_press(self, event):
        item = self.get_item_under_cursor(event)
        if item in self.hex_items:
            y, x = self.hex_items[item]
            self.current_brush = 0 if self.grid[y][x] == 1 else 1
            self.set_hex(y, x, self.current_brush)
            self.update_status()

    def on_drag(self, event):
        item = self.get_item_under_cursor(event)
        if item in self.hex_items:
            y, x = self.hex_items[item]
            self.set_hex(y, x, self.current_brush)
            self.update_status()

    def get_item_under_cursor(self, event):
        cx = self.canvas.canvasx(event.x)
        cy = self.canvas.canvasy(event.y)
        items = self.canvas.find_overlapping(cx - 1, cy - 1, cx + 1, cy + 1)
        for i in reversed(items):
            if i in self.hex_items:
                return i
        return None

    def fill_lime(self):
        for y in range(ROWS):
            for x in range(COLS):
                self.set_hex(y, x, 1)
        self.update_status()

    def fill_holes(self):
        for y in range(ROWS):
            for x in range(COLS):
                self.set_hex(y, x, 0)
        self.update_status()

    def invert_all(self):
        for y in range(ROWS):
            for x in range(COLS):
                self.set_hex(y, x, 1 - self.grid[y][x])
        self.update_status()

    def update_status(self):
        lime_cnt = sum(row.count(1) for row in self.grid)
        hole_cnt = (ROWS * COLS) - lime_cnt
        self.status_lbl.config(text=f"Holes (Black): {hole_cnt} | Solid (Lime): {lime_cnt}")

    def export_scad(self):
        filename = filedialog.asksaveasfilename(
            defaultextension=".scad",
            filetypes=[("OpenSCAD files", "*.scad"), ("All files", "*.*")],
            initialfile="pattern_array.scad"
        )
        if not filename:
            return

        with open(filename, "w") as f:
            f.write("// Auto-generated OpenSCAD Pattern Array\n")
            f.write(f"// Dimensions: {ROWS} rows x {COLS} cols\n")
            f.write("// Format: row 0 is bottom, row 42 is top\n")
            f.write("pattern_array = [\n")
            for y in range(ROWS):
                row_vals = ", ".join(str(val) for val in self.grid[y])
                comma = "," if y < ROWS - 1 else ""
                f.write(f"  [{row_vals}]{comma} // row {y}\n")
            f.write("];\n")

        messagebox.showinfo("Export Successful", f"Saved matrix to:\n{filename}")

    def load_scad(self):
        filename = filedialog.askopenfilename(
            filetypes=[("OpenSCAD files", "*.scad"), ("All files", "*.*")]
        )
        if not filename:
            return

        try:
            with open(filename, "r") as f:
                content = f.read()

            # 1. Strip comments line-by-line first so brackets in comments are ignored
            clean_lines = []
            for line in content.splitlines():
                code_only = line.split("//")[0].strip()
                if code_only:
                    clean_lines.append(code_only)
            clean_text = " ".join(clean_lines)

            # 2. Support OpenSCAD true/false if edited manually
            clean_text = clean_text.replace("true", "1").replace("false", "0")

            # 3. Locate array brackets
            start = clean_text.find("[")
            end = clean_text.rfind("]")
            if start == -1 or end == -1:
                raise ValueError("Could not find array delimiters '[' and ']' in file.")

            matrix_str = clean_text[start:end + 1]

            # 4. Safe AST parsing
            matrix = ast.literal_eval(matrix_str)

            # Populate grid
            for y in range(min(ROWS, len(matrix))):
                for x in range(min(COLS, len(matrix[y]))):
                    self.set_hex(y, x, 1 if matrix[y][x] else 0)

            self.update_status()
            messagebox.showinfo("Loaded", "Pattern successfully loaded!")
        except Exception as e:
            messagebox.showerror("Parse Error", f"Failed to parse OpenSCAD file:\n{e}")

if __name__ == "__main__":
    root = tk.Tk()
    root.geometry("660x900")
    app = HexGridDesigner(root)
    root.mainloop()