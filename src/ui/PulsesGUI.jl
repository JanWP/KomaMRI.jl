loadbutton = filepicker()
columnbuttons = Observable{Any}(dom"div"())
data = Observable{Any}(Array{Sequence})
map!(f->begin
        print("Loading... $f\n")
        JLD2.load(FileIO.File{FileIO.DataFormat{:JLD2}}(f),"seq")
    end
    , data, loadbutton)

hh, ww = 600, 600
l = PlotlyJS.Layout(;
    scene=attr(xaxis_title="kx [m^-1]",
            yaxis_title="ky [m^-1]",
            zaxis_title=L"kz [m^-1]",),
    modebar=attr(orientation="v"),height=hh,width=ww,hovermode="closest",
    scene_camera_eye=attr(x=0, y=0, z=2),
    scene_camera_up=attr(x=0, y=1., z=0),include_mathjax=true)
p = MRIsim.plot_seq(seq)
plt = Observable{Any}(p)

function makebuttons(seq)
    namesseq = ["Sequence","k-space"]
    buttons = button.(string.(namesseq))
    for (btn, name) in zip(buttons, namesseq)
        if name == "Sequence"
            map!(t-> begin
                    MRIsim.plot_seq(seq)
                end
                , plt, btn)
        elseif name == "k-space"
            map!(t->begin
                ACQ = seq.GR.DAC #is_DAC_on.(seq)
                #Adding gradients before and after acq, to show the centered k-space
                ACQ = (circshift(ACQ,1)+circshift(ACQ,-1)+ACQ).!=0 #TODO: Change to accumulated moment-0
                seqADC = sum(seq[ACQ])
                kspace = MRIsim.get_designed_kspace(seqADC)
                N = size(kspace,1)-1
                M = size(kspace,2)
                c = ["hsv($((i-1)/N*255),255,25)" for i=1:N-1]
                lines = PlotlyJS.scatter3d(x=kspace[:,1],y=kspace[:,2],z=kspace[:,3],mode="lines",
                        line=attr(color=c),aspectratio=1)
                p = PlotlyJS.plot(lines,l)
            end
            , plt, btn)
        end
    end
    dom"div"(hbox(buttons))
end
map!(makebuttons, columnbuttons, data)

columnbuttons = makebuttons(seq)
pulseseq = dom"div"(loadbutton, columnbuttons, plt)
content!(w, "div#content", pulseseq)
