'# MWS Version: Version 2019.0 - Sep 20 2018 - ACIS 28.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4 fmax = 7
'# created = '[VERSION]2015.2|24.0.2|20150403[/VERSION]


'@ use template: Antenna - Planar

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With
'----------------------------------------------------------------------------
Plot.DrawBox True
With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mue "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With
With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With
' optimize mesh settings for planar structures
With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With
With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With
With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With
' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"
' switch on FD-TET setting for accurate farfields
FDSolver.ExtrudeOpenBC "True"
PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"
'----------------------------------------------------------------------------
'set the frequency range
Solver.FrequencyRange "2", "3"
Dim sDefineAt As String
sDefineAt = "2;2.4;3"
Dim sDefineAtName As String
sDefineAtName = "2;2.4;3"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")
Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)
Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)
' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .Frequency zz_val
    .Create
End With
' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .Frequency zz_val
    .Create
End With
' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .Frequency zz_val
    .ExportFarfieldSource "False"
    .Create
End With
Next
'----------------------------------------------------------------------------
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")

'@ define material: FR-4 (lossy)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.025" 
.TanDFreq "10.0" 
.TanDGiven "True" 
.TanDModel "ConstTanD" 
.KappaM "0.0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstKappa" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "General 1st" 
.DispersiveFittingSchemeMue "General 1st" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.Rho "0.0" 
.ThermalType "Normal" 
.ThermalConductivity "0.3" 
.SetActiveMaterial "all" 
.Colour "0.94", "0.82", "0.76" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With

'@ new component: Substrate

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Component.New "Substrate"

'@ define brick: Substrate:solid1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "Substrate" 
     .Material "FR-4 (lossy)" 
     .Xrange "-X/2", "X/2" 
     .Yrange "-Y/2", "Y/2" 
     .Zrange "-SubT", "0" 
     .Create
End With

'@ define material: Copper (annealed)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static" 
.Type "Normal" 
.SetMaterialUnit "Hz", "mm" 
.Epsilon "1" 
.Mue "1.0" 
.Kappa "5.8e+007" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
.TanDModel "ConstTanD" 
.KappaM "0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstTanD" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "Nth Order" 
.DispersiveFittingSchemeMue "Nth Order" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.FrqType "all" 
.Type "Lossy metal" 
.SetMaterialUnit "GHz", "mm" 
.Mue "1.0" 
.Kappa "5.8e+007" 
.Rho "8930.0" 
.ThermalType "Normal" 
.ThermalConductivity "401.0" 
.HeatCapacity "0.39" 
.MetabolicRate "0" 
.BloodFlow "0" 
.VoxelConvection "0" 
.MechanicsType "Isotropic" 
.YoungsModulus "120" 
.PoissonsRatio "0.33" 
.ThermalExpansionRate "17" 
.Colour "1", "1", "0" 
.Wireframe "False" 
.Reflection "False" 
.Allowoutline "True" 
.Transparentoutline "False" 
.Transparency "0" 
.Create
End With

'@ new component: Ground

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Component.New "Ground"

'@ define brick: Ground:solid2

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "Ground" 
     .Material "Copper (annealed)" 
     .Xrange "-X/2", "X/2" 
     .Yrange "-Y/2", "Y/2" 
     .Zrange "-SubT-MetT", "-SubT" 
     .Create
End With

'@ define curve line: curve1:line1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0.0" 
     .Y1 "-Y/2" 
     .X2 "0.0" 
     .Y2 "-l/2+insert" 
     .Create
End With

'@ new component: Top

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Component.New "Top"

'@ define tracefromcurve: Top:solid3

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid3" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:line1" 
     .Thickness "MetT" 
     .Width "MW82" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ pick face

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickFaceFromId "Top:solid3", "4"

'@ define port: 1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label "" 
     .NumberOfModes "1" 
     .AdjustPolarization "False" 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Orientation "positive" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "-1", "1" 
     .Yrange "-50", "-50" 
     .Zrange "0", "0.035" 
     .XrangeAdd "MlineW*8", "MlineW*8" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "SubT", "SubT*10" 
     .SingleEnded "False" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "True"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ define brick: Top:solid4

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Brick
     .Reset 
     .Name "solid4" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Xrange "-w/2", "w/2" 
     .Yrange "-l/2", "l/2" 
     .Zrange "0", "MetT" 
     .Create
End With

'@ define brick: Top:solid5

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Brick
     .Reset 
     .Name "solid5" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Xrange "-MW82/2-gap", "MW82/2+gap" 
     .Yrange "-l/2", "-l/2+insert" 
     .Zrange "0", "MetT" 
     .Create
End With

'@ boolean subtract shapes: Top:solid4, Top:solid5

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Subtract "Top:solid4", "Top:solid5"

'@ define time domain solver parameters

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ switch working plane

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Plot.DrawWorkplane "false"

'@ set parametersweep options

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
    .SetSimulationType "Transient" 
End With

'@ add parsweep sequence: Sequence 1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddSequence "Sequence 1" 
End With

'@ add parsweep parameter: Sequence 1:insert

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "insert", "1", "13", "21", "False" 
End With

'@ delete parsweep parameter: Sequence 1:insert

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "insert" 
End With

'@ add parsweep parameter: Sequence 1:l

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "l", "27", "29", "3", "False" 
End With

'@ edit parsweep parameter: Sequence 1:l

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "l" 
     .AddParameter_Samples "Sequence 1", "l", "27", "29", "6", "False" 
End With

'@ set mesh properties (Hexahedral)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Mesh 
     .MeshType "PBA" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "20" 
     .Set "StepsPerWaveFar", "20" 
     .Set "WavelengthRefinementSameAsNear", "1" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "20" 
     .Set "StepsPerBoxFar", "1" 
     .Set "MaxStepNear", "0" 
     .Set "MaxStepFar", "0" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     .Set "UseMaxStepAbsolute", "0" 
     .Set "GeometryRefinementSameAsNear", "0" 
     'MIN CELL 
     .Set "UseRatioLimitGeometry", "1" 
     .Set "RatioLimitGeometry", "20" 
     .Set "MinStepGeometryX", "0" 
     .Set "MinStepGeometryY", "0" 
     .Set "MinStepGeometryZ", "0" 
     .Set "UseSameMinStepGeometryXYZ", "1" 
End With 
With MeshSettings 
     .Set "PlaneMergeVersion", "2" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "FaceRefinementOn", "0" 
     .Set "FaceRefinementPolicy", "2" 
     .Set "FaceRefinementRatio", "2" 
     .Set "FaceRefinementStep", "0" 
     .Set "FaceRefinementNSteps", "2" 
     .Set "EllipseRefinementOn", "0" 
     .Set "EllipseRefinementPolicy", "2" 
     .Set "EllipseRefinementRatio", "2" 
     .Set "EllipseRefinementStep", "0" 
     .Set "EllipseRefinementNSteps", "2" 
     .Set "FaceRefinementBufferLines", "3" 
     .Set "EdgeRefinementOn", "1" 
     .Set "EdgeRefinementPolicy", "1" 
     .Set "EdgeRefinementRatio", "6" 
     .Set "EdgeRefinementStep", "0" 
     .Set "EdgeRefinementBufferLines", "3" 
     .Set "RefineEdgeMaterialGlobal", "0" 
     .Set "RefineAxialEdgeGlobal", "0" 
     .Set "BufferLinesNear", "3" 
     .Set "UseDielectrics", "1" 
     .Set "EquilibrateOn", "0" 
     .Set "Equilibrate", "1.5" 
     .Set "IgnoreThinPanelMaterial", "0" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "SnapToAxialEdges", "1"
     .Set "SnapToPlanes", "1"
     .Set "SnapToSpheres", "1"
     .Set "SnapToEllipses", "1"
     .Set "SnapToCylinders", "1"
     .Set "SnapToCylinderCenters", "1"
     .Set "SnapToEllipseCenters", "1"
End With 
With Discretizer 
     .MeshType "PBA" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAccuracyEnhancement "enable"
     .ConnectivityCheck "False"
     .ConvertGeometryDataAfterMeshing "True" 
     .UsePecEdgeModel "True" 
     .GapDetection "False" 
     .FPBAGapTolerance "1e-3" 
     .SetMaxParallelMesherThreads "Hex", "12"
     .SetParallelMesherMode "Hex", "Maximum"
     .PointAccEnhancement "0" 
     .UseSplitComponents "True" 
     .EnableSubgridding "False" 
     .PBAFillLimit "99" 
     .AlwaysExcludePec "False" 
End With

'@ delete monitors

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Monitor.Delete "e-field (f=2)" 
Monitor.Delete "e-field (f=2.4)" 
Monitor.Delete "e-field (f=3)" 
Monitor.Delete "farfield (f=2)" 
Monitor.Delete "farfield (f=2.4)" 
Monitor.Delete "farfield (f=3)" 
Monitor.Delete "h-field (f=2)" 
Monitor.Delete "h-field (f=2.4)" 
Monitor.Delete "h-field (f=3)"

'@ define frequency range

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solver.FrequencyRange "4", "7"

'@ define monitor: e-field (f=5.8)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=5.8)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .Frequency "5.8" 
     .UseSubvolume "False" 
     .SetSubvolume  "-48.626929909091",  "48.626929909091",  "-48.626929909091",  "48.626929909091",  "-15.231929909091",  "29.361929909091" 
     .Create 
End With

'@ define monitor: h-field (f=5.8)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.8)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .Frequency "5.8" 
     .UseSubvolume "False" 
     .SetSubvolume  "-48.626929909091",  "48.626929909091",  "-48.626929909091",  "48.626929909091",  "-15.231929909091",  "29.361929909091" 
     .Create 
End With

'@ define farfield monitor: farfield (f=5.8)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=5.8)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "5.8" 
     .UseSubvolume "False" 
     .ExportFarfieldSource "False" 
     .SetSubvolume  "-48.626929909091",  "48.626929909091",  "-48.626929909091",  "48.626929909091",  "-15.231929909091",  "29.361929909091" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "True"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

''@ transform: translate Ground
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Ground" 
'     .Vector "dis", "0", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ transform: translate Substrate
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Substrate" 
'     .Vector "dis", "0", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ boolean insert shapes: Substrate:solid1_1, Substrate:solid1
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'Solid.Insert "Substrate:solid1_1", "Substrate:solid1"
'
'@ transform: translate Ground

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Ground" 
     .Vector "dis", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Substrate

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Substrate" 
     .Vector "dis", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid4

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid4" 
     .Vector "dis", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ boolean insert shapes: Substrate:solid1, Substrate:solid1_1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Insert "Substrate:solid1", "Substrate:solid1_1"

'@ transform: translate Ground

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Ground" 
     .Vector "-dis/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Substrate

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Substrate" 
     .Vector "-dis/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Top" 
     .Vector "-dis/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete port: port1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Port.Delete "1"

'@ delete shape: Top:solid3

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Delete "Top:solid3"

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "-dis/2", "0" 
     .RLine "0", "-l/2-LineToPatch" 
     .RLine "dis", "0" 
     .RLine "0", "l/2+LineToPatch" 
     .Create 
End With

'@ define tracefromcurve: Top:solid5

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid5" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:polygon1" 
     .Thickness "MetT" 
     .Width "MW82" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ pick edge

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickEdgeFromId "Top:solid5", "18", "14"

'@ chamfer edges of: Top:solid5

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChamferEdge "1.5", "45", "False", "7"

'@ pick edge

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickEdgeFromId "Top:solid5", "15", "12"

'@ chamfer edges of: Top:solid5

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChamferEdge "1.5", "45", "False", "6"

'@ define curve line: curve1:line1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0.0" 
     .Y1 "-l/2-LineToPatch" 
     .X2 "0.0" 
     .Y2 "-l/2-LineToPatch-QW58" 
     .Create
End With

'@ define tracefromcurve: Top:solid6

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid6" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:line1" 
     .Thickness "MetT" 
     .Width "MW58" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ define curve line: curve1:line1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0.0" 
     .Y1 "-l/2-LineToPatch" 
     .X2 "0.0" 
     .Y2 "-Y/2" 
     .Create
End With

'@ define tracefromcurve: Top:solid7

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid7" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:line1" 
     .Thickness "MetT" 
     .Width "MW82" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ pick face

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickFaceFromId "Top:solid7", "2"

'@ define port: 1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label "" 
     .NumberOfModes "1" 
     .AdjustPolarization "False" 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Orientation "positive" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "-0.5", "0.5" 
     .Yrange "-17.5", "-17.5" 
     .Zrange "0", "0.035" 
     .XrangeAdd "MW82*8", "MW82*8" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "SubT", "SubT*10" 
     .SingleEnded "False" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ delete parsweep parameter: Sequence 1:l

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "l" 
End With

'@ add parsweep parameter: Sequence 1:QW58

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "QW58", "5.5", "6", "10", "False" 
End With

''@ transform: mirror Ground
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Ground" 
'     .Origin "Free" 
'     .Center "0", "-Y/2", "0" 
'     .PlaneNormal "0", "1", "0" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ transform: mirror Substrate
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Substrate" 
'     .Origin "Free" 
'     .Center "0", "-Y/2", "0" 
'     .PlaneNormal "0", "1", "0" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ transform: mirror Top:solid4
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Top:solid4" 
'     .Origin "Free" 
'     .Center "0", "-Y/2", "0" 
'     .PlaneNormal "0", "1", "0" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ transform: mirror Top:solid4_1
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Top:solid4_1" 
'     .Origin "Free" 
'     .Center "0", "-Y/2", "0" 
'     .PlaneNormal "0", "1", "0" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "True" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ transform: mirror Top:solid5
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Transform 
'     .Reset 
'     .Name "Top:solid5" 
'     .Origin "Free" 
'     .Center "0", "-Y/2", "0" 
'     .PlaneNormal "0", "1", "0" 
'     .MultipleObjects "True" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .Destination "" 
'     .Material "" 
'     .Transform "Shape", "Mirror" 
'End With
'
'@ transform: translate Ground

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Ground" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Substrate

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Substrate" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid4

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid4" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid4_1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid4_1" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid5

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid5" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ boolean insert shapes: Substrate:solid1_2, Substrate:solid1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Insert "Substrate:solid1_2", "Substrate:solid1"

'@ boolean insert shapes: Substrate:solid1_1_1, Substrate:solid1_1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Insert "Substrate:solid1_1_1", "Substrate:solid1_1"

'@ transform: translate Ground

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Ground" 
     .Vector "0", "l/2+LineToPatch+dis/2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Substrate

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Substrate" 
     .Vector "0", "l/2+LineToPatch+dis/2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Transform 
     .Reset 
     .Name "Top" 
     .Vector "0", "l/2+LineToPatch+dis/2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define curve line: curve1:line1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0.0" 
     .Y1 "-dis/2" 
     .X2 "0.0" 
     .Y2 "-dis/2+QW58" 
     .Create
End With

'@ define tracefromcurve: Top:solid8

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid8" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:line1" 
     .Thickness "MetT" 
     .Width "MW58" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ delete shape: Top:solid7

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Delete "Top:solid7"

'@ define curve line: curve1:line1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0.0" 
     .Y1 "dis/2" 
     .X2 "0.0" 
     .Y2 "-dis/2" 
     .Create
End With

'@ define tracefromcurve: Top:solid9

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid9" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:line1" 
     .Thickness "MetT" 
     .Width "MW82" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ delete port: port1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Port.Delete "1"

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "-10", "0" 
     .RLine "12", "0" 
     .RLine "QW45", "QW45" 
     .Create 
End With

'@ define tracefromcurve: Top:solid10

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid10" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:polygon1" 
     .Thickness "MetT" 
     .Width "MW45" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ define curve polygon: curve1:polygon1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "-10", "0" 
     .RLine "12", "0" 
     .RLine "7", "7" 
     .LineTo "(X+dis)/2", "7" 
     .Create 
End With

'@ define tracefromcurve: Top:solid11

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid11" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:polygon1" 
     .Thickness "MetT" 
     .Width "MlineW" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ pick face

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickFaceFromId "Top:solid11", "4"

'@ define port: 1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label "" 
     .NumberOfModes "1" 
     .AdjustPolarization "False" 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Orientation "positive" 
     .PortOnBound "False" 
     .ClipPickedPortToBound "False" 
     .Xrange "32.5", "32.5" 
     .Yrange "5.5", "8.5" 
     .Zrange "0", "0.035" 
     .XrangeAdd "0.0", "0.0" 
     .YrangeAdd "MlineW*8", "MlineW*8" 
     .ZrangeAdd "SubT", "SubT*10" 
     .SingleEnded "False" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "True"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ pick edge

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickEdgeFromId "Top:solid10", "12", "10"

'@ chamfer edges of: Top:solid10

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChamferEdge "4", "22.5", "False", "5"

'@ pick edge

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickEdgeFromId "Top:solid11", "18", "14"

'@ chamfer edges of: Top:solid11

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChamferEdge "4", "22.5", "False", "7"

'@ pick edge

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickEdgeFromId "Top:solid11", "6", "6"

'@ chamfer edges of: Top:solid11

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChamferEdge "4", "22.5", "False", "3"

'@ pick face

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Pick.PickFaceFromId "Top:solid10", "6"

''@ define extrude: Top:solid12
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'With Extrude 
'     .Reset 
'     .Name "solid12" 
'     .Component "Top" 
'     .Material "Copper (annealed)" 
'     .Mode "Picks" 
'     .Height "10" 
'     .Twist "0.0" 
'     .Taper "0.0" 
'     .UsePicksForHeight "False" 
'     .DeleteBaseFaceSolid "False" 
'     .ClearPickedFace "True" 
'     .Create 
'End With
'
''@ boolean add shapes: Top:solid10, Top:solid12
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'Solid.Add "Top:solid10", "Top:solid12"
'
''@ clear picks
'
''[VERSION]2015.2|24.0.2|20150403[/VERSION]
'Pick.ClearAllPicks
'
'@ define curve line: curve1:line1

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "-10" 
     .Y1 "0.0" 
     .X2 "0.0" 
     .Y2 "0.0" 
     .Create
End With

'@ define tracefromcurve: Top:solid12

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid12" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Curve "curve1:line1" 
     .Thickness "MetT" 
     .Width "MW45" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .GapType "2" 
     .Create 
End With

'@ boolean insert shapes: Top:solid10, Top:solid12

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Insert "Top:solid10", "Top:solid12"

'@ boolean subtract shapes: Top:solid11, Top:solid12

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.Subtract "Top:solid11", "Top:solid12"

'@ define time domain solver parameters

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set mesh properties (Hexahedral)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Mesh 
     .MeshType "PBA" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "10" 
     .Set "StepsPerWaveFar", "10" 
     .Set "WavelengthRefinementSameAsNear", "1" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "10" 
     .Set "StepsPerBoxFar", "1" 
     .Set "MaxStepNear", "0" 
     .Set "MaxStepFar", "0" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     .Set "UseMaxStepAbsolute", "0" 
     .Set "GeometryRefinementSameAsNear", "0" 
     'MIN CELL 
     .Set "UseRatioLimitGeometry", "1" 
     .Set "RatioLimitGeometry", "20" 
     .Set "MinStepGeometryX", "0" 
     .Set "MinStepGeometryY", "0" 
     .Set "MinStepGeometryZ", "0" 
     .Set "UseSameMinStepGeometryXYZ", "1" 
End With 
With MeshSettings 
     .Set "PlaneMergeVersion", "2" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "FaceRefinementOn", "0" 
     .Set "FaceRefinementPolicy", "2" 
     .Set "FaceRefinementRatio", "2" 
     .Set "FaceRefinementStep", "0" 
     .Set "FaceRefinementNSteps", "2" 
     .Set "EllipseRefinementOn", "0" 
     .Set "EllipseRefinementPolicy", "2" 
     .Set "EllipseRefinementRatio", "2" 
     .Set "EllipseRefinementStep", "0" 
     .Set "EllipseRefinementNSteps", "2" 
     .Set "FaceRefinementBufferLines", "3" 
     .Set "EdgeRefinementOn", "1" 
     .Set "EdgeRefinementPolicy", "1" 
     .Set "EdgeRefinementRatio", "6" 
     .Set "EdgeRefinementStep", "0" 
     .Set "EdgeRefinementBufferLines", "3" 
     .Set "RefineEdgeMaterialGlobal", "0" 
     .Set "RefineAxialEdgeGlobal", "0" 
     .Set "BufferLinesNear", "3" 
     .Set "UseDielectrics", "1" 
     .Set "EquilibrateOn", "0" 
     .Set "Equilibrate", "1.5" 
     .Set "IgnoreThinPanelMaterial", "0" 
End With 
With MeshSettings 
     .SetMeshType "Hex" 
     .Set "SnapToAxialEdges", "1"
     .Set "SnapToPlanes", "1"
     .Set "SnapToSpheres", "1"
     .Set "SnapToEllipses", "1"
     .Set "SnapToCylinders", "1"
     .Set "SnapToCylinderCenters", "1"
     .Set "SnapToEllipseCenters", "1"
End With 
With Discretizer 
     .MeshType "PBA" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAccuracyEnhancement "enable"
     .ConnectivityCheck "False"
     .ConvertGeometryDataAfterMeshing "True" 
     .UsePecEdgeModel "True" 
     .GapDetection "False" 
     .FPBAGapTolerance "1e-3" 
     .SetMaxParallelMesherThreads "Hex", "12"
     .SetParallelMesherMode "Hex", "Maximum"
     .PointAccEnhancement "0" 
     .UseSplitComponents "True" 
     .EnableSubgridding "False" 
     .PBAFillLimit "99" 
     .AlwaysExcludePec "False" 
End With

'@ delete parsweep parameter: Sequence 1:QW58

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "QW58" 
End With

'@ add parsweep parameter: Sequence 1:QW45

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "QW45", "3", "5", "10", "False" 
End With

'@ define monitor: e-field (f=6.02)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=6.02)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .Frequency "6.02" 
     .UseSubvolume "False" 
     .SetSubvolume  "-46.126929909091",  "46.126929909091",  "-37.526929909091",  "54.726929909091",  "-15.231929909091",  "29.361929909091" 
     .Create 
End With

'@ define monitor: h-field (f=6.02)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=6.02)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .Frequency "6.02" 
     .UseSubvolume "False" 
     .SetSubvolume  "-46.126929909091",  "46.126929909091",  "-37.526929909091",  "54.726929909091",  "-15.231929909091",  "29.361929909091" 
     .Create 
End With

'@ define farfield monitor: farfield (f=6.02)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=6.02)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "6.02" 
     .UseSubvolume "False" 
     .ExportFarfieldSource "False" 
     .SetSubvolume  "-46.126929909091",  "46.126929909091",  "-37.526929909091",  "54.726929909091",  "-15.231929909091",  "29.361929909091" 
     .Create 
End With

'@ define material: FR-4 (loss free)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With Material
     .Reset
     .Name "FR-4 (loss free)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
.TanDModel "ConstTanD" 
.KappaM "0.0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstKappa" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "General 1st" 
.DispersiveFittingSchemeMue "General 1st" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.Rho "0.0" 
.ThermalType "Normal" 
.ThermalConductivity "0.3"
.SetActiveMaterial "all" 
.Colour "0.75", "0.95", "0.85" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With

'@ change material: Substrate:solid1 to: FR-4 (loss free)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChangeMaterial "Substrate:solid1", "FR-4 (loss free)"

'@ change material: Substrate:solid1_1 to: FR-4 (loss free)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChangeMaterial "Substrate:solid1_1", "FR-4 (loss free)"

'@ change material: Substrate:solid1_1_1 to: FR-4 (loss free)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChangeMaterial "Substrate:solid1_1_1", "FR-4 (loss free)"

'@ change material: Substrate:solid1_2 to: FR-4 (loss free)

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
Solid.ChangeMaterial "Substrate:solid1_2", "FR-4 (loss free)"

'@ delete parsweep parameter: Sequence 1:QW45

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "QW45" 
End With

'@ add parsweep parameter: Sequence 1:QW45

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "QW45", "4.5", "7", "9", "False" 
End With

'@ delete parsweep parameter: Sequence 1:QW45

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "QW45" 
End With

'@ add parsweep parameter: Sequence 1:QW58

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "QW58", "7", "9", "7", "False" 
End With

'@ edit parsweep parameter: Sequence 1:QW58

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "QW58" 
     .AddParameter_Samples "Sequence 1", "QW58", "9.2", "10.5", "6", "False" 
End With

'@ delete parsweep parameter: Sequence 1:QW58

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .DeleteParameter "Sequence 1", "QW58" 
End With

'@ add parsweep parameter: Sequence 1:w

'[VERSION]2015.2|24.0.2|20150403[/VERSION]
With ParameterSweep
     .AddParameter_Samples "Sequence 1", "w", "14", "16", "8", "False" 
End With

'@ boolean add shapes: Substrate:solid1, Substrate:solid1_1

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Add "Substrate:solid1", "Substrate:solid1_1"

'@ boolean add shapes: Substrate:solid1, Substrate:solid1_1_1

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Add "Substrate:solid1", "Substrate:solid1_1_1"

'@ boolean add shapes: Substrate:solid1, Substrate:solid1_2

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Add "Substrate:solid1", "Substrate:solid1_2"

'@ change material: Substrate:solid1 to: FR-4 (lossy)

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.ChangeMaterial "Substrate:solid1", "FR-4 (lossy)"

'@ change material: Substrate:solid1 to: FR-4 (loss free)

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.ChangeMaterial "Substrate:solid1", "FR-4 (loss free)"

'@ change material and color: Substrate:solid1 to: FR-4 (loss free)

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.ChangeMaterial "Substrate:solid1", "FR-4 (loss free)" 
Solid.SetUseIndividualColor "Substrate:solid1", 1
Solid.ChangeIndividualColor "Substrate:solid1", "128", "128", "192"

'@ boolean add shapes: Ground:solid2, Ground:solid2_1

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Add "Ground:solid2", "Ground:solid2_1"

'@ boolean add shapes: Ground:solid2, Ground:solid2_1_1

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Add "Ground:solid2", "Ground:solid2_1_1"

'@ boolean add shapes: Ground:solid2, Ground:solid2_2

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Add "Ground:solid2", "Ground:solid2_2"

'@ boolean insert shapes: Top:solid5, Top:solid4

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid5", "Top:solid4"

'@ boolean insert shapes: Top:solid5, Top:solid4_1

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid5", "Top:solid4_1"

'@ boolean insert shapes: Top:solid5_1, Top:solid4_1_1

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid5_1", "Top:solid4_1_1"

'@ boolean insert shapes: Top:solid5_1, Top:solid4_2

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid5_1", "Top:solid4_2"

'@ boolean insert shapes: Top:solid9, Top:solid6

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid9", "Top:solid6"

'@ boolean insert shapes: Top:solid9, Top:solid8

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid9", "Top:solid8"

'@ boolean insert shapes: Top:solid11, Top:solid10

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Solid.Insert "Top:solid11", "Top:solid10"

'@ switch bounding box

'[VERSION]2016.6|25.0.2|20161004[/VERSION]
Plot.DrawBox "False"

'@ define curve polygon: curve1:polygon1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "-23", "20.5" 
     .LineTo "-20.5", "18" 
     .LineTo "-23", "18" 
     .LineTo "-23", "20.5" 
     .Create 
End With

'@ define extrudeprofile: Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "solid12" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Thickness "MetT" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .DeleteProfile "True" 
     .Curve "curve1:polygon1" 
     .Create
End With

'@ define curve polygon: curve1:polygon1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "-9.5", "18" 
     .LineTo "-7", "20.5" 
     .LineTo "-7", "18" 
     .LineTo "-9.5", "18" 
     .Create 
End With

'@ delete shape: Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid12"

'@ delete curve item: curve1:polygon1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Curve.DeleteCurveItem "curve1", "polygon1"

'@ define brick: Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Xrange "-23", "-20" 
     .Yrange "18", "21" 
     .Zrange "0", "MetT" 
     .Create
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "13", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "dis", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1" 
     .Vector "dis", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_2" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ boolean subtract shapes: Top:solid4, Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4", "Top:solid12"

'@ boolean subtract shapes: Top:solid4, Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4", "Top:solid12_1"

'@ boolean subtract shapes: Top:solid4_1, Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4_1", "Top:solid12_1_1"

'@ boolean subtract shapes: Top:solid4_1, Top:solid12_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4_1", "Top:solid12_2"

'@ boolean subtract shapes: Top:solid4_1_1, Top:solid12_1_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4_1_1", "Top:solid12_1_1_1"

'@ boolean subtract shapes: Top:solid4_1_1, Top:solid12_2_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4_1_1", "Top:solid12_2_1"

'@ boolean subtract shapes: Top:solid4_2, Top:solid12_1_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4_2", "Top:solid12_1_2"

'@ boolean subtract shapes: Top:solid4_2, Top:solid12_3

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Subtract "Top:solid4_2", "Top:solid12_3"

'@ delete shape: Top:solid4

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid4"

'@ delete shape: Top:solid4_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid4_1_1"

'@ delete shape: Top:solid4_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid4_2"

'@ delete shape: Top:solid4_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid4_1"

'@ define curve circle: curve1:circle1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "4" 
     .Xcenter "-19" 
     .Ycenter "28" 
     .Segments "0" 
     .Create
End With

'@ define extrudeprofile: Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "solid12" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Thickness "MetT" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .DeleteProfile "True" 
     .Curve "curve1:circle1" 
     .Create
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "4", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "dis", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "0", "-3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1" 
     .Vector "0", "-3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "0", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "0", "-1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_2" 
     .Vector "0", "-3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: Top:solid5_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid5_1"

'@ delete shape: Top:solid5

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
Solid.Delete "Top:solid5"

'@ define curve polygon: curve1:polygon1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Polygon 
     .Reset 
     .Name "polygon1" 
     .Curve "curve1" 
     .Point "-15", "19" 
     .LineTo "-13", "19" 
     .LineTo "-13", "17" 
     .LineTo "11", "17" 
     .LineTo "11", "19" 
     .LineTo "13", "19" 
     .LineTo "13", "15" 
     .LineTo "-15", "15" 
     .LineTo "-15", "19" 
     .Create 
End With

'@ define curve blend: curve1:blend1 on: polygon1,polygon1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With BlendCurve 
  .Reset 
  .Name "blend1" 
  .Radius "1" 
  .Curve "curve1" 
  .CurveItem1 "polygon1" 
  .CurveItem2 "polygon1" 
  .EdgeId1 "7" 
  .EdgeId2 "8" 
  .VertexId1 "8" 
  .VertexId2 "8" 
  .Create 
End With

'@ define curve blend: curve1:blend2 on: polygon1,polygon1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With BlendCurve 
  .Reset 
  .Name "blend2" 
  .Radius "1" 
  .Curve "curve1" 
  .CurveItem1 "polygon1" 
  .CurveItem2 "polygon1" 
  .EdgeId1 "6" 
  .EdgeId2 "7" 
  .VertexId1 "7" 
  .VertexId2 "7" 
  .Create 
End With

'@ define extrudeprofile: Top:solid13

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With ExtrudeCurve
     .Reset 
     .Name "solid13" 
     .Component "Top" 
     .Material "Copper (annealed)" 
     .Thickness "metT" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .DeleteProfile "True" 
     .Curve "curve1:polygon1" 
     .Create
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "1", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1" 
     .Vector "-3", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid13

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid13" 
     .Vector "0", "-dis", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "-3", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_2" 
     .Vector "1", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid13_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid13_1" 
     .Vector "0", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_2" 
     .Vector "0", "-2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "0", "-1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "0", "-1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12" 
     .Vector "0", "-0.1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1" 
     .Vector "0", "-0.1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_1_1

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_1_1" 
     .Vector "0", "-0.2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate Top:solid12_2

'[VERSION]2019.0|28.0.2|20180920[/VERSION]
With Transform 
     .Reset 
     .Name "Top:solid12_2" 
     .Vector "0", "-0.2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With 

