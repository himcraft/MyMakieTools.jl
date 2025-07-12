module MyMakieTools
using Makie
export IntegerTicks
export mytheme, savefig, get_tickvalues, logaxis
export get_palette_colors, dualAxis, syncDualAxes!
struct IntegerTicks end
Makie.get_tickvalues(::IntegerTicks, vmin, vmax) = ceil(Int, vmin) : floor(Int, vmax)
#====
https://web.archive.org/web/20220705182930/https://s-rip.github.io/report/colourdefinition.html
====#

"""
    mytheme([colorusage])

Return a modified Makie.Theme. 

`colorusage`: choose different palette according to the features of the data.
- :categorical[default] => glasbey_category10_n256
- :doublet => tab20
- :diverging => roma10
- :cyclic => romaO10
- :srip => [srip project](https://web.archive.org/web/20220705185841/https://s-rip.github.io/report/colourtables.html)
- :comb => black-red-blue-pink-green-orange

For more palettes, see https://juliagraphics.github.io/ColorSchemes.jl/stable/catalogue/

# Usage
    set_theme!(mytheme())
"""
function mytheme(colorusage=:categorical)
    if colorusage==:categorical
        COLORSCHEME=Makie.ColorSchemes.glasbey_category10_n256.colors
    elseif colorusage==:doublet
        COLORSCHEME=Makie.ColorSchemes.tab20.colors
    elseif colorusage==:diverging
        COLORSCHEME=Makie.ColorSchemes.roma10.colors
    elseif colorusage==:cyclic
        COLORSCHEME=Makie.ColorSchemes.romaO10.colors
    elseif colorusage==:srip
        COLORSCHEME=["#e21f26","#e4789b","#295f8a","#5f98c6","#afcbe3","#723b7a","#ad71b5","#d6b8da","#f57e20","#fdbf6e","#ec008c","#f799D1","#00aeef","#60c8e8","#34a048","#b35b28","#ffd700"]
    elseif colorusage==:comb
        COLORSCHEME=["#000000","#ff0000","#0000ff","#008000","#cc87a4","#2ca02c","#ff7f0e"]
    else
        COLORSCHEME=Makie.colorschemes[colorusage].colors
    end
    myTheme=Theme(
        palette=(
            color=COLORSCHEME,
        ),
        Axis=(
            xgridvisible=false,
            ygridvisible=false,
            xminorticksvisible=true,
            yminorticksvisible=true,
            xlabelsize=30,
            ylabelsize=30,
            xtickalign=1,
            ytickalign=1,
            xminortickalign=1,
            yminortickalign=1,
        ),
        Legend=(
            framevisible=false,
            poisition=:lt,
            labelsize=25,
            patchsize=(40,20),
        ),
        Lines=(
            linewidth=2,
        ),
        VLines=(
            color=:red,
            linestyle=:dash,
        ),
        HLines=(
            color=:red,
            linestyle=:dash,
        ),
        fontsize=25,
    )
    myTheme=merge(myTheme,theme_latexfonts())
    return myTheme
end

"""
    savefig(name::String,f::Figure;pdf=false,png=false,prefix="",res=1,dpi=600)

Display and save Makie.Figure as pdf and/or png and/or svg.
"""
function savefig(name::String,f::Figure;pdf=false,png=false,svg=false,prefix="",res=1,dpi=600)
	if(pdf)
	save(prefix*name*".pdf",f,pt_per_unit=0.75res)
	end
	if(png)
	save(prefix*name*".png",f,px_per_unit=res*dpi/96)
	end
    if(svg)
    save(prefix*name*".svg",f,pt_per_unit=0.75res)
    end
	display(f)
end

"""
    logaxis(f::Figure,x::Bool=true,y::Bool=true;axpos=[1,1],title::AbstractString="",xlabel::AbstractString="",ylabel::AbstractString="")

Return a Makie.Axis with x and/or y scales as log10.
"""
function logaxis(f::Figure,x::Bool=true,y::Bool=true;axpos=[1,1],title::AbstractString="",xlabel::AbstractString="",ylabel::AbstractString="")::Axis
    xscl=x ? log10 : identity
    yscl=y ? log10 : identity
    ax=Axis(f[axpos[1],axpos[2]],xscale=xscl,yscale=yscl,title=title,xlabel=xlabel,ylabel=ylabel)
    if(x)
        ax.xminorticks=IntervalsBetween(9)
        ax.xticks=LogTicks(IntegerTicks())
    end
    if(y)
        ax.yminorticks=IntervalsBetween(9)
        ax.yticks=LogTicks(IntegerTicks())
    end
    return ax
end

"""
    get_palette_colors([show::Bool=false])

Return the current Makie color palette as an array. 

When `show` is `true`, returns colors as `RGB{Float64}` objects. 
When `false` (default), returns the raw color values from the theme.
"""
function get_palette_colors()
    theme = Makie.current_default_theme()
    return theme.palette.color.val
    # return Makie.current_default_theme().palette.color.val
end

function get_palette_colors(show::Bool)
    colorstr=get_palette_colors()
    if show
        return [Makie.Colors.RGB{Float64}(parse(Makie.Colors.RGB, c)) for c in colorstr]
    else
        return colorstr
    end
end

"""
dualAxis(f::GridPosition;)

Return two Makie.Axes in the same position, one for left y-axis and one for right y-axis.
"""
function dualAxis(f::GridPosition;ax2color=:red)
    ax1=Axis(f[1,1])
    ax1.rightspinecolor = :transparent
    ax2=Axis(f[1,1], yaxisposition = :right,
    yticklabelcolor = ax2color, 
    ylabelcolor = ax2color, 
    rightspinecolor = ax2color,
    ytickcolor = ax2color,
    yminortickcolor = ax2color,
    )
    hidexdecorations!(ax2)
    return (ax1, ax2)
end

"""
    dualAxis(f::Figure,axpos=[1,1];)

Return two Makie.Axes in the same position, one for left y-axis and one for right y-axis.
"""
function dualAxis(f::Figure,axpos=[1,1];ax2color=:red)
    f_layout = f[axpos[1],axpos[2]]
    return dualAxis(f_layout;ax2color=ax2color)
end

"""
    syncDualAxes!(ax1, ax2)
    
Synchronize the x-axis of two Makie.Axes.
"""
function syncDualAxes!(ax1, ax2)
    if !isnothing(ax1.limits.val[1])
        xlims!(ax2, ax1.limits.val[1])
    end
    ax2.xscale = ax1.xscale.val
end

end # module MyMakieTools
