#include <stdio.h>
#include <stdlib.h>
#include "setContact.h"

double[] setContact(boolean[] inOnOOB, double[] wallContactVector, doublep[] orthogonalWallContactVector, double[] particleLocation, double[] line)
{
	for particleIndex = 1:len(inOOB)
		if(inOnOOB(particleIndex) == 1)
			wallContact[particleIndex] = wallContactVector;
			orthogonalWallContact(particleIndex,:) = orthogonalWallContactVector;
			dists(particleIndex) = obj.distPointToLine(particleLocation, Line[0,1], line[2,3]);
\\dists(particleIndex) = obj.distPointToLine(particleLocation(particleIndex,:), polygon.currentPoly(outOfBoundsCount,:), polygon.currentPoly(outOfBoundsCount + 1,:));
\\particleInc = particleInc + 1;
		}
	}
}

\\DistPointToLine:
distPointToLine(obj,point,lineA,lineB)
a = lineA - lineB;
b = point - lineB;
a(3) = 0;
b(3) = 0;
dist = norm(cross(a,b)) / norm(a);