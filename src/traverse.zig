//! File for traversing across a document and formatting it appropriately.

const ts = @import("tree-sitter");

const Cursor = ts.Cursor;

pub const Formatter = struct {
    cursor: Cursor,

    pub fn init(start_node: ts.Node) !Formatter {
        var cursor = try ts.Cursor.init(start_node);

        return .{
            .cursor = cursor,
        };
    }

    pub fn deinit(self: Cursor) void {
        self.cursor.deinit();
    }

    // TODO: perhaps make this return a string instead of a node?
    pub fn next() ?ts.Node {
        
    }
};

pub fn format(formatter: Formatter, tree: ts.Tree) []const u8 {
    while (formatter.next()) |node| {

    }
}
