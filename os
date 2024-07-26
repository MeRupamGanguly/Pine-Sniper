// This Pine Script™ code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © opulencesniper

//@version=5
indicator("opulencesniper", overlay = true, max_lines_count = 500, max_boxes_count = 500)
bullAreaCss      = input.color(color.new(color.teal, 50), 'Area'     , inline = 'bull')
bearAreaCss      = input.color(color.new(color.red, 50), 'Area'      , inline = 'bear')

n = bar_index

type fvg
    float top
    float btm
    bool  mitigated
    bool  isnew
    bool  isbull
    line  lvl
    box   area

method set_fvg(fvg id, offset, bg_css, l_css)=>
    avg = math.avg(id.top, id.btm)
    area  = box.new(n - offset, id.top, n, id.btm, na, bgcolor = bg_css)
    avg_l = line.new(n - offset, avg, n, avg, color = l_css, style = line.style_dashed)

    id.lvl := avg_l
    id.area := area

bull_fvg = low > high[2] and close[1] > high[2]
bear_fvg = high < low[2] and close[1] < low[2]
var fvg sfvg = fvg.new(na, na, na, true, na)
if bull_fvg 
    sfvg := fvg.new(low, high[2], false, false, true)
    sfvg.set_fvg(2, bullAreaCss, bullAreaCss)
else if bear_fvg 
    sfvg := fvg.new(low[2], high, false, false, false)
    sfvg.set_fvg(2, bearAreaCss, bearAreaCss)
if not sfvg.isnew
    sfvg.lvl.set_x2(n+5)
    sfvg.area.set_right(n+5)