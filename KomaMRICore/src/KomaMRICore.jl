module KomaMRICore

#IMPORT PACKAGES
import Base.*, Base.+, Base.-, Base./, Base.vcat, Base.size, Base.abs, Base.getproperty
#General
using Reexport, ThreadsX, Pkg
#Printing
using Scanf, ProgressMeter
#Datatypes
using Parameters
#Simulation
using Interpolations
@reexport using CUDA
#Reconstruction
using MRIBase, MRIFiles
@reexport using MRIBase: Profile, RawAcquisitionData, AcquisitionData, AcquisitionHeader
@reexport using MRIFiles: ISMRMRDFile
#IO
using FileIO, HDF5, MAT, JLD2

global γ = 42.5774688e6; #Hz/T gyromagnetic constant for H1, JEMRIS uses 42.5756 MHz/T

#Hardware
include("datatypes/Scanner.jl")
#Sequence
include("datatypes/sequence/Grad.jl")
include("datatypes/sequence/RF.jl")
include("datatypes/sequence/ADC.jl")
include("simulation/KeyValuesCalculation.jl")
include("datatypes/Sequence.jl")
include("datatypes/sequence/Delay.jl")
include("sequences/PulseDesigner.jl")
include("io/Pulseq.jl")
#Phantom
include("datatypes/Phantom.jl")
include("io/JEMRIS.jl")
include("io/MRiLab.jl")
#Simulator
include("datatypes/simulation/DiscreteSequence.jl")
include("datatypes/simulation/Spinor.jl")
include("simulation/TimeStepCalculation.jl")
include("simulation/other/DiffusionModel.jl")
include("simulation/GPUFunctions.jl")
# include("simulation/other/OffResonanceModel.jl")
include("simulation/TrapezoidalIntegration.jl")
include("simulation/SimulatorCore.jl")
include("io/ISMRMRD.jl")
#UI
include("ui/DisplayFunctions.jl")

#Main
export γ #gyro-magnetic ratio [Hz/T]
export Scanner, Sequence, Phantom
export Grad, RF, ADC, Delay
export Mag, dur
#Pulseq
export read_seq
#ISMRMRD
export signal_to_raw_data
#Phantom
export brain_phantom2D, brain_phantom3D, read_phantom_jemris, read_phantom_MRiLab
#Spinors
export Spinor, Rx, Ry, Rz, Q, Un
#Secondary
export PulseDesigner, get_kspace, rotx, roty, rotz
#Display
export plot_seq, plot_grads_moments, plot_kspace, plot_phantom_map, plot_signal, plot_M0, plot_image, plot_dict
#Simulator
export simulate, simulate_slice_profile

export print_gpus

#Additionals
using PlotlyJS

koma_core_version = VersionNumber(Pkg.TOML.parsefile(joinpath(@__DIR__, "..", "Project.toml"))["version"])
export koma_core_version

end
