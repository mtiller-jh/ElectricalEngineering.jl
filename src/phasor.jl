export j,phasor,pol

doc"""
`j = 1im` equals the imaginary unit
"""
const j=1im

doc"""
# Function call

`pol(r,phi)`

# Description

Creates a complex quantity with length `r` and angle `phi`

# Variables

`r` Length of complex quantity; r may be utilized including a unit generated by
Unitful

`phi` Angle of complex quantity; if module Unitful is utilized, the angle may be
specified in degrees, by using unit `°`

# Examples

```julia
julia> using Unitful,Unitful.DefaultSymbols,EE
julia> U1=pol(2V,pi)
-2 + 0im V
julia> U2=pol(sqrt(2)*1V,45°)
1 + 1im V
```
"""
function pol(r,phi)
  return r*cos(phi)+1im*r*sin(phi)
end

doc"""
# Function call

`phasor(c;origin=0.0+0.0im,ref=1,par=0,
    rlabel=0.5,tlabel=0.1,label="",ha="center",va="center",
    relrot=false,relangle=0,
    color="black",linesstyle="-",linewidth=1,
    width=0.2,headlength=10,headwidth=5)`

# Description

This function draws a phasor from a starting point `origin` and end point
`origin`+`c`. The phasor consists of a shaft and an arrow head.

Each phasor c is plotted as a relative quantity, i.e., `c/ref` is actually
shown the plot figure. This concept of plotting a per unit phasor is used to
be able to plot phasor with different quantities, e.g., voltage and current
phasors. It is important that the variables `c`, `origin` and `ref` have the
same units (defined through Unitful).

# Variables

`c` Complex phasor, drawn relative relative to `origin`

`origin` Complex number representing the origin of the phasor; this variable
needs to have the same unit as `c`

`ref` Reference length of scaling; this is required as in a phasor diagram
voltages and currents may be included; in order to account for the different
voltage and current scales, one (constant)  `ref` is used for voltage
phasors and another (constant) `ref` is used for current phasors; this
variable needs to have the same unit as `c`

`par` In order to be able to plot parallel phasors, par is used to specify
the per unit tangential shift (offset) of a phasor, with respect to `ref`;
so typically `ref` will be selected to be around 0.05 to 0.1;
default value = 0 (no shift of phasor)

`rlabel` Radial per unit location of label (in direction of the phasor):
`rlabel = 0` represents the shaft of the phasor and `rlabel = 1` represents
the arrow hear of the phasor; default value = 0.5, i.e., the radial center
of the phasor

`tlabel` Tangential per unit location of label: `tlabel = 0` means that the
label is plotted onto the phasor; `tlabel = -0.25` plots the label on top of
the phasor applying a displacement of 25% with respect to `ref`;
`tlabel` Plots the label below the
phasor applying a displacement of 20% with respect to `ref`; default value
= 0.25

`ha` Horizontal alignment of label; actually represents the tangential
alignment of the label; default value = "center"

`va` Vertical alignment of label; actually represents the radial
alignment of the label; default value = "center"

`relrot` Relative rotation of label; if `relrot == false` (default value)
then the label is not rotated relative to the orientation of the phasor;
otherwise the label is rotated relative to the phasor by the angle
`relangle` (indicated in degrees)

`relangle` Relative angle of label in degree with respect to phasor
orientation; this angle is only applied, it `relrot == true`; this angle the
indicates the relative orientation of the label with respect to the
orientation of the phasor; default value = 0

`color` Color of the phasor; i.e., shaft and arrow head color; default
value = "black"

`linestyle` Line style of the phasor; default value = "-"

`linewidth` Line width of the phasor; default value = 1

`width` Line width of the shaft line; default value = 0.2

`headlength` Length of arrow head; default value = 10

`headwidth` Width of arrow head; default value = 5

# Example

Copy and paste code:

```julia
using Unitful,Unitful.DefaultSymbols,PyPlot,EE
figure(figsize=(3.3,2.5))
rc("text",usetex=true);
rc("font", family="serif")

V1 = 100V+j*0V # Voltage
Z1 = 30Ω+j*40Ω # Impedance
I1 = V1/Z1       # Current
Vr = real(Z1)*I1
Vx = V1-Vr
refV = abs(V1); refI=abs(I1)*0.8
phasor(V1,label=L"$\underline{V}_1$",tlabel=-0.1,ref=refV,relrot=true)
phasor(Vr,label=L"$\underline{V}_r$",tlabel=-0.1,ref=refV,relrot=true)
phasor(Vx,origin=Vr,label=L"$\underline{V}_x$",tlabel=0.15,ref=refV,relrot=true)
phasor(I1,label=L"$\underline{I}_1$",tlabel=0.2,rlabel=0.7,ref=refI,relrot=true,linestyle="--",par=0.05)
axis("square"); xlim(-1,1); ylim(-1,1)
ax=gca(); ax[:set_axis_off](); # Remove axis
# save3fig("phasordiagram",crop=true);
```

"""
function phasor(c;origin=(0.0+0.0im).*c./ustrip(c),
    ref=abs(c./ustrip(c)),par=0.0,
    rlabel=0.5,tlabel=0.1,
    label="",
    ha="center",va="center",
    relrot=false,relangle=0.0,
    color="black",linestyle="-",linewidth=1,
    width=0.2,headlength=10.0,headwidth=5.0)

    # Check if units of c, origin and ref are compatible
    # Starting point (origin) of phase
    xorigin=0.0
    yorigin=0.0
    xend=0.0
    yend=0.0
    try
        xorigin=uconvert(Unitful.NoUnits,real(origin)./ref)
        yorigin=uconvert(Unitful.NoUnits,imag(origin)./ref)
        # End point of phasor
        xend=uconvert(Unitful.NoUnits,real(origin+c)./ref)
        yend=uconvert(Unitful.NoUnits,imag(origin+c)./ref)
    catch err
        error("module EE: function phasor: Dimension mismatch of arguments `c`, `origin` and `ref`\n    The arguments `c`, `origin` and `ref` must have the same dimension (koherent SI unit)")
    end

    # Real part of phasor
    drx=xend-xorigin # = real(c)./ref
    # Imag part of phasor
    dry=yend-yorigin # = imag(c)./ref
    # Length of phasor
    dr=sqrt(drx^2+dry^2)
    # Angle of phasor in degrees
    absangle=atan2(dry,drx)*180/pi
    # Orientation tangential to phasor (lagging by 90°)
    # Real part of tangential component with repsect to length
    dtx=+dry/dr
    # Imag part of tangential component with repsect to length
    dty=-drx/dr
    # Real part of parallel shift of phasor
    dpx=par*dtx
    # Imag part of parallel shift of phasor
    dpy=par*dty
    # Origin of head
    xoriginHead = xorigin + drx*0.99
    yoriginHead = yorigin + dry*0.99
    # Draw arrow shaft and head
    # https://matplotlib.org/api/_as_gen/matplotlib.pyplot.annotate.html?highlight=annotate#matplotlib.pyplot.annotate
    # Draw shaft separately: otherwise, the arrow contour will be drawn as in
    # https://matplotlib.org/users/annotations.html#basic-annotation
    # so that the back and forth paths overlap and the line style does not
    # appear correctly; replace
    plot([xorigin+dpx,xend+dpx],[yorigin+dpy,yend+dpy],
        color=color,linestyle=linestyle,linewidth=linewidth)
    # Code based on plot replaces the previous implementation inspired by:
    # https://stackoverflow.com/questions/51746400/linestyle-in-plot-and-annotate-are-not-equal-in-matplotlib
    # Previous (obsolete) implementation:
    # annotate("",xy=(xend+dpx,yend+dpy),
    #     xytext=(xorigin+dpx,yorigin+dpy),xycoords="data",
    #     arrowprops=Dict("arrowstyle"=>"-",
    #         "linestyle"=>linestyle,
    #         "linewidth"=>linewidth,
    #         "color"=>color,
    #         "facecolor"=>color),
    #     annotation_clip=false)

    # Draw arrow head without line style; this is a workaround explained in
    # https://stackoverflow.com/questions/47180328/pyplot-dotted-line-with-fancyarrowpatch/47205418#47205418
    annotate("",xy=(xend+dpx,yend+dpy),
        xytext=(xoriginHead+dpx,yoriginHead+dpy),xycoords="data",
        arrowprops=Dict("edgecolor"=>color,"facecolor"=>color,
            "width"=>width,"linestyle"=>"-",
            "headlength"=>headlength,
            "headwidth"=>headwidth),
        annotation_clip=false)

    # Plot label
    if relrot==false
        # Without relative roation of label
        text(xorigin+drx*rlabel+dtx*tlabel+dpx,
            yorigin+dry*rlabel+dty*tlabel+dpy,
            label,ha=ha,va=va,rotation=relangle)
    else
        # Applying relative rotation of label
        text(xorigin+drx*rlabel+dtx*tlabel+dpx,
            yorigin+dry*rlabel+dty*tlabel+dpy,
            label,ha=ha,va=va,rotation=absangle+relangle)
    end
end
