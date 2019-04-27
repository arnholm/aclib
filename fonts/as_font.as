
// AngelCAD fonts base class

class as_font {
   
   double spacer = 1.0;
   
   // generate a 2d shape from a single character
   // this function is overridden in the derived classes
   shape2d@ character(const string &in c) { return null; }

   // generate a 2d shape from a single line of text
   // if the length is given > 0, scale the returned shape to given value
   shape2d@ text_line(const string &in txt, double length=-1)
   {
      
      double xoff   = 0.0;                           // xoff = offset to start of next character
      double cspace = spacer*character(".").box().dx(); // space between characters
      double blank  = character("e").box().dx();     // size of blank space
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
};

