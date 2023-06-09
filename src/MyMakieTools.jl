module MyMakieTools
using Makie
export IntegerTicks
export mytheme, savefig, get_tickvalues, logaxis
struct IntegerTicks end
Makie.get_tickvalues(::IntegerTicks, vmin, vmax) = ceil(Int, vmin) : floor(Int, vmax)
#====
https://web.archive.org/web/20220705182930/https://s-rip.github.io/report/colourdefinition.html
https://web.archive.org/web/20220705185841/https://s-rip.github.io/report/colourtables.html
====#
sripcolor=["#e21f26","#e4789b","#295f8a","#5f98c6","#afcbe3","#723b7a","#ad71b5","#d6b8da","#f57e20","#fdbf6e","#ec008c","#f799D1","#00aeef","#60c8e8","#34a048","#b35b28","#ffd700"]
pltcolor=sripcolor #TODO: will be removed later

"""
    mytheme()

Return a modified Makie.Theme. 

# Usage
    set_theme!(mytheme())
"""
function mytheme()
    myTheme=Theme(
        palette=(
            color=pltcolor,
            # color=cgrad(ColorSchemes.tab10.colors,10,categorical=true)
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
        fonts=(;regular="Times New Roman",bold="Times New Roman Bold",italic="Times New Roman Italic"),
    )
    return myTheme
end

"""
    savefig(name::String,f::Figure;pdf=false,png=false,prefix="")

Display and save Makie.Figure as pdf and/or png.
"""
function savefig(name::String,f::Figure;pdf=false,png=false,prefix="")
	if(pdf)
	save(prefix*name*".pdf",f,pt_per_unit=10)
	end
	if(png)
	save(prefix*name*".png",f,px_per_unit=10)
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
