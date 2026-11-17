import std.stdio;
import std.file;
import std.string;
import std.array;
import std.conv;

void main(string[] args) {
    writeln("Reading MAIN.LIB for FAT77 integration...");

    if (!exists("MAIN.LIB")) {
        writeln("Error: MAIN.LIB not found.");
        return;
    }

    string libContent = readText("MAIN.LIB");
    string domain = "trafo.com";
    string trafoFlow = "main -> trafo.com -> zudus.lib";

    foreach (line; lineSplitter(libContent)) {
        string trimmed = strip(line);
        if (trimmed.startsWith("DOMAIN =")) {
            domain = strip(trimmed[8..$]);
        } else if (trimmed.startsWith("TRAFO =")) {
            trafoFlow = strip(trimmed[7..$]);
        }
    }

    writeln("Parsed Domain: ", domain);
    writeln("Parsed Flow: ", trafoFlow);

    enum size_t SECTOR_SIZE = 512;
    enum size_t TOTAL_SECTORS = 32;
    enum size_t IMAGE_SIZE = SECTOR_SIZE * TOTAL_SECTORS;

    ubyte[] diskImage = new ubyte[IMAGE_SIZE];
    diskImage[] = 0x00;

    string headerPayload = "FAT77-SIG|DOMAIN:" ~ domain ~ "|TRAFO:" ~ trafoFlow;
    ubyte[] headerBytes = cast(ubyte[]) headerPayload;

    if (headerBytes.length > SECTOR_SIZE) {
        headerBytes = headerBytes[0 .. SECTOR_SIZE];
    }

    diskImage[0 .. headerBytes.length] = headerBytes[];

    string outputFilename = "fat77.img";
    std.file.write(outputFilename, diskImage);

    writeln("Successfully generated ", outputFilename, " with embedded MAIN.LIB metadata (Size: ", IMAGE_SIZE, " bytes).");
}
