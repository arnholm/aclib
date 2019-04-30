
// AngelCAD fonts base class

class as_font {
   
   double xspacer = 1.0;
   double yspacer = 1.0;
   
   // generate a 2d shape from a single character
   // this function is overridden in the derived classes
   shape2d@ character(const string &in c) { return null; }

   // generate a 2d shape from a single line of text
   // if the length is given > 0, scale the returned shape to given value
   shape2d@ text(const string &in txt, double length=-1)
   {
      
      double xoff   = 0.0;                              // xoff = offset to start of next character
      double cspace = xspacer*character(".").box().dx(); // space between characters
      double blank  = character("e").box().dx();        // size of blank space
      shape2d@ t_shape = null;
      for(uint i=0; i<txt.size(); i++) {
         
         // shape for next character
         shape2d@ c_shape = character(txt.substr(i,1)); 
         if(@c_shape != null) {
            
            // adjust offset so bottom left of character starts where we last ended
            boundingbox@ b = c_shape.box();
            xoff -= b.p1().x();
            
            // add in the shape of the new character
            if(@t_shape == null) @t_shape = translate(xoff,0)*c_shape;
            else       @t_shape = t_shape + translate(xoff,0)*c_shape;
            
            // adjust offset with size of character + standard spacer
            xoff += b.dx() + cspace;
         }
         else {
            xoff += blank;  // blank space offset
         }
      }
      
      // possibly scale the resulting shape to given length
      if(length > 0.0) @t_shape = scale(length/xoff)*t_shape;
      return t_shape;
   }
   
   // generate a 2d shape from an array of text lines
   // if the length is given > 0, scale the returned shape to given value
   shape2d@ text(array<string> &in txt, double length=-1)
   {
      shape2d@ t_shape = null;
      double max_len   = 0.0;
      double yoff_prev = 0.0;
      double yoff      = 0.0;
      double cspace = yspacer*character(".").box().dy(); // space between lines
      for(uint i=0; i<txt.size(); i++) {
         if(txt[i].length() > 0) {
            shape2d@ shape_line = text(txt[i]);
            boundingbox@ b = shape_line.box();
            max_len = (max_len > b.dx())? max_len : b.dx();
            if(@t_shape == null) @t_shape = translate(0,yoff)*shape_line;
            else       @t_shape = t_shape + translate(0,yoff)*shape_line;
            yoff_prev = yoff;
            yoff -= b.dy() + cspace;
         }
      }
      // possibly scale the resulting shape to given length
      if(length > 0.0) @t_shape = scale(abs(length/max_len))*translate(0,-yoff_prev)*t_shape;
      return t_shape;
   }
};

