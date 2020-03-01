import fused.fuse;
import std.range;
import std.string;
import std.stdio; // FIXME
import std.file;
import std.path;
import core.stdc.string;
import core.sys.posix.sys.stat;

class MyFS : Operations
{
    private string root_path;

    this(string _root_path) {
        root_path = _root_path;
    }

    override void getattr(const(char)[] path, ref stat_t stat) {
        writeln("getattr");
        lstat((root_path~'/'~path).toStringz, &stat);
    }
    override ulong read(const(char)[] path, ubyte[] buf, ulong offset) {
        writeln("read");
        auto file = File(root_path~'/'~path, "rb");
        file.seek(offset);
        file.rawRead(buf);
        file.close();
        return buf.length;
    }
    override int write(const(char)[] path, in ubyte[] data, ulong offset) {
        writeln("write");
        auto file = File(root_path~'/'~path, "wb");
        file.seek(offset);
        file.rawWrite(data);
        file.close();
        return cast(int) data.length; // FIXME: wrong
    }
    //override void truncate(const(char)[] path, ulong length);
    override string[] readdir(const(char)[] path) {
        writeln("readdir");
        import std.algorithm;
        return [".", ".."] ~
            dirEntries(cast(string) (root_path~'/'~path), SpanMode.shallow, false).map!(a => baseName(a.name)).array;
    }
    override size_t readlink(const(char)[] path, ubyte[] buf) {
        writeln("readlink");
        immutable link = readLink(root_path~'/'~path);
        memcpy(&buf[0], &link[0], link.length); // FIXME: max length
        buf[link.length] = 0; // FIXME: needed?
        return link.length;
    }
    override bool access(const(char)[] path, int mode) {
        writeln("access");
        return true; // FIXME
    }
}