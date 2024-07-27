# Pine-Sniper

// This Pine Script™ code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © opulencesniper

//@version=5
indicator("opulencesniper", overlay = true, max_lines_count = 500, max_boxes_count = 500)
bullAreaCss      = input.color(color.new(color.teal, 50), 'Area'     , inline = 'bull')
bearAreaCss      = input.color(color.new(color.red, 50), 'Area'      , inline = 'bear')

n = bar_index //  represents the index of the current bar on the chart. This is used to keep track of the position in time.

type fvg
    float top // The top price level of the fair value gap.
    float btm // The bottom price level of the fair value gap.
    bool  mitigated // A boolean indicating if the gap has been mitigated.
    bool  isnew // A boolean indicating if the gap is new.
    bool  isbull // A boolean indicating if the gap is bullish.
    line  lvl // A line object representing the average price level of the gap.
    box   area // A box object representing the visual area of the gap.

method set_fvg(fvg id, offset, bg_css, l_css)=>
    avg = math.avg(id.top, id.btm) // calculates the average price level between the top and bottom of the gap.
    // creates a new box object to represent the gap area on the chart, 
    area  = box.new(n - offset, id.top, n, id.btm, na, bgcolor = bg_css)
    // creates a new dashed line object at the average price level,
    avg_l = line.new(n - offset, avg, n, avg, color = l_css, style = line.style_dashed)

    // The id.lvl and id.area fields of the fvg object are updated with the newly created line and box.
    id.lvl := avg_l
    id.area := area
// is true if the current low is greater than the high of two bars ago and the previous close is also greater than the high of two bars ago.
bull_fvg = low > high[2] and close[1] > high[2]
// is true if the current high is less than the low of two bars ago and the previous close is also less than the low of two bars ago.
bear_fvg = high < low[2] and close[1] < low[2]
// sfvg is a variable of type fvg, initialized with na (not available) values, except isnew which is set to true. This is used to store the current fair value gap.
var fvg sfvg = fvg.new(na, na, na, true, na)
// If bull_fvg is true, sfvg is updated with the new fair value gap using the current low and the high of two bars ago. It then calls set_fvg() with the bull color settings.
// If bear_fvg is true, sfvg is updated with the new fair value gap using the low of two bars ago and the current high. It then calls set_fvg() with the bear color settings.
if bull_fvg 
    sfvg := fvg.new(low, high[2], false, false, true)
    sfvg.set_fvg(2, bullAreaCss, bullAreaCss)
else if bear_fvg 
    sfvg := fvg.new(low[2], high, false, false, false)
    sfvg.set_fvg(2, bearAreaCss, bearAreaCss)
// If sfvg is not a new gap (isnew is false), it updates the end position of the line (sfvg.lvl) and the right side of the box (sfvg.area) to extend 5 bars into the future. This ensures that the gap remains visible on the chart beyond the current bar.
if not sfvg.isnew
    sfvg.lvl.set_x2(n+5)
    sfvg.area.set_right(n+5)