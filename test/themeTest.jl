function themeTest(giventitle,N)
    f=Figure()
    ax=Axis(f[1,1],xlabel="xlabel",ylabel="ylabel",title=giventitle)
    x=collect(Float64,0:0.1:10)
    for i=1:N
        lines!(ax,x,0.1*(i-1)*sin.(x)+0.1*(9-i)*cos.(x),label="$i")
    end
    Legend(f[1,2],ax,nbanks=1)
    display(f)
    return f
end

function gen_themeTest()
    set_theme!()
    savefig("default_example",themeTest("Default theme",5),pdf=false,png=true,prefix="./files/");
    set_theme!(mytheme(:categorical))
    savefig("categorical_example",themeTest("mytheme(:categorical)",5),pdf=false,png=true,prefix="./files/");
end