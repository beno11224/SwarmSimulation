%polygon = polygon from Polygons.m
%polygon.currentPoly is then a collection of points

%this should set it up...
polygon = Polygons(0.01);
polygon.change(2);

%mesh generation
tr = triangulation(polyshape(polygon.currentPoly(:,1),polygon.currentPoly(:,2)));
model = createpde(1);
tnodes = tr.Points';
telements = tr.ConnectivityList';
model.geometryFromMesh(tnodes, telements);
mesh = generateMesh(model, 'Hmax', 0.001);

%Writing to file:
fileidone = fopen('MeshAndPolygon.csv','w');
for i = 1:length(mesh.Nodes)
    fprintf(fileidone, mesh.Nodes(1,i) + "," + mesh.Nodes(2,i) + "\r");
end            
    fprintf(fileidone, "Poylgon" + "," + "Below" + "\r");
for i = 1: length(polygon.currentPoly)
    fprintf(fileidone, polygon.currentPoly(i,1) + "," + polygon.currentPoly(i,2) + "\r");
end                        
fclose(fileidone);