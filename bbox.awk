# bbox.awk -- resets bounding box in eps document
BEGIN{
  bbox="0,0,0,0";
  split(bbox,BoundingBox,",");
}
{ if (!match($1,"%%BoundingBox")) print $0; }
/^%%BoundingBox/{
  split(bbox,BoundingBox,",");
  printf("%s %i %i %i %i\n","%%BoundingBox:",
	  BoundingBox[1],BoundingBox[2],BoundingBox[3],BoundingBox[4]);
}
