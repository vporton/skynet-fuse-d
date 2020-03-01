import std.stdio;
import fused.fuse;
import fs;

void main(string[] args)
{
    /* foreground=true, threading=false */
    auto fs = new Fuse("SiaFS", true, false);
    fs.mount(new MyFS(args[1]), args[2], [/*"allow_other"*/]); // FIXME
}