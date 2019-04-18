// AngelCAD library code: #include "aclib/trim.as"
// Author: Carsten Arnholm
// License MIT

/*
Example use:
   solid@ trimmed =  trim(object:sphere(100),pos:pos3d(80,0,0),normal:vec3d(1,0,1));
*/


// cutting plane is normal to X axis
solid@ trim_x(solid@ object, double pos, double dir)
{
   return trim(object,pos3d(pos,0,0),vec3d(dir,0,0));
}

// cutting plane is normal to Y axis
solid@ trim_y(solid@ object, double pos, double dir)
{
   return trim(object,pos3d(0,pos,0),vec3d(0,dir,0));
}

// cutting plane is normal to Z axis
solid@ trim_z(solid@ object, double pos, double dir)
{
   return trim(object,pos3d(0,0,pos),vec3d(0,0,dir));
}

// Trim away material from object
// ==============================
// object : the object to be trimmed
// pos    : a position in the cutting plane
// normal : trim plane normal. Material in this direction will be removed
// returns: trimmed object
solid@ trim(solid@ object, pos3d@ pos, vec3d@ normal, double angtol=1.0E-3)
{
   return object - planar_cutting_tool(object,pos,normal,angtol);
}

// Create planar cutting tool
// ===========================
// object : the object to be trimmed
// pos    : a position in the cutting plane
// normal : trim plane normal. Material in this direction will be removed
// returns: Trimming tool, properly sized, rotated and positioned
solid@ planar_cutting_tool(solid@ object, pos3d@ pos, vec3d@ normal, double angtol=1.0E-3)
{
   // Construct a transformation to position the trimming tool.
   // Begin by defining local x,y,z directions for the tool
   const vec3d yvec(0,1,0),zvec(0,0,1);
   double az = normal.angle(zvec) % PI;  // normalise the angle [0,PI>
   locsys3d@ lsys = (az > angtol)? locsys3d(normal,zvec) : locsys3d(normal,yvec);
 
   // Homogeneous transformation matrix T.
   // this makes the cutting tool start in the given position "pos"
   // and have the tool material in the direction of the normal
   hmatrix T(lsys.x(),lsys.y(),lsys.z(),pos);
   
   // length is longer than the object in all directions
   boundingbox@ box = object.box();
   double length    = box.diagonal()*1.1; // scale up to make sure
      
   // compute the projection point of the object center  down to the 
   // x-axis of the tool, and from that compute the tool offset so it
   // completely encapsulates the object in the tool y & z directions
   line3d line(pos,pos+normal);
   pos3d@ pc   = box.center();
   pos3d@ proj = line.interpolate(line.project(pc));
   vec3d  offset(proj,pc);
 
   // create and position the trimming tool
   solid@ tool = translate(offset) *
                 T *
                 translate(0,-0.5*length,-0.5*length) *
                 cube(length);
    
   return tool;
}
