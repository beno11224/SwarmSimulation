%% About defineHapticSpoofTest.mlx
% This file defines the MATLAB interface to the library |HapticSpoofTest|.
%
% Commented sections represent C++ functionality that MATLAB cannot automatically define. To include
% functionality, uncomment a section and provide values for &lt;SHAPE&gt;, &lt;DIRECTION&gt;, etc. For more
% information, see <matlab:helpview(fullfile(docroot,'matlab','helptargets.map'),'cpp_define_interface') Define MATLAB Interface for C++ Library>.



%% Setup
% Do not edit this setup section.
function libDef = defineHapticSpoofTest()
libDef = clibgen.LibraryDefinition("HapticSpoofTestData.xml");
%% OutputFolder and Libraries 
libDef.OutputFolder = "D:\Uni\Simulations\SwarmSimulation";
libDef.Libraries = "";

%% C++ function |main| with MATLAB name |clib.HapticSpoofTest.main|
% C++ Signature: int main(int argc,char * [] argv)
%mainDefinition = addFunction(libDef, ...
%    "int main(int argc,char * [] argv)", ...
%    "MATLABName", "clib.HapticSpoofTest.main", ...
%    "Description", "clib.HapticSpoofTest.main Representation of C++ function main."); % Modify help description values as needed.
%defineArgument(mainDefinition, "argc", "int32");
%defineArgument(mainDefinition, "argv", "string", "input", <SHAPE>);
%defineOutput(mainDefinition, "RetVal", "int32");
%validate(mainDefinition);

%% Validate the library definition
validate(libDef);

end
