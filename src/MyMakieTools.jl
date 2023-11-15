module MyMakieTools
using Makie
export IntegerTicks
export mytheme, savefig, get_tickvalues, logaxis
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
        COLORSCHEME=["#000000","#ff0000","#0000ff","#cc87a4","#2ca02c","#ff7f0e"]
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
    savefig(name::String,f::Figure;pdf=false,png=false,prefix="")

Display and save Makie.Figure as pdf and/or png.
"""
function savefig(name::String,f::Figure;pdf=false,png=false,prefix="",res=10)
	if(pdf)
	save(prefix*name*".pdf",f,pt_per_unit=res)
	end
	if(png)
	save(prefix*name*".png",f,px_per_unit=res)
	end
	display(f)
end

"""
    logaxis(f::Figure,x::Bool=true,y::Bool=true;axpos=[1,1],title::AbstractString="",xlabel::AbstractString="",ylabel::AbstractString="",aspectratio=4/3)

Return a Makie.Axis with x and/or y scales as log10.
"""
function logaxis(f::Figure,x::Bool=true,y::Bool=true;axpos=[1,1],title::AbstractString="",xlabel::AbstractString="",ylabel::AbstractString="",aspectratio=4/3)::Axis
    xscl=x ? log10 : identity
    yscl=y ? log10 : identity
    ax=Axis(f[axpos[1],axpos[2]],xscale=xscl,yscale=yscl,title=title,xlabel=xlabel,ylabel=ylabel,aspect=aspectratio)
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
end # module MyMakieTools
