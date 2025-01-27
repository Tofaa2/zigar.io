const std = @import("std");
const rl = @import("raylib");

pub const Entity = struct {
    position: rl.Vector2,
    data: EntityData,

    pub fn draw(self: Entity) void {
        var radius: f32 = 0;
        var color = rl.Color.green;
        if (self.data == .player) {
            radius = @as(f32, @floatFromInt(self.data.player.mass)) / 10;
            color = self.data.player.color;
        } else if (self.data == .mother) {}

        rl.drawCircle(@intFromFloat(self.position.x), @intFromFloat(self.position.y), radius, color);
    }
};

pub const EntityData = union(enum) {
    mother: MotherData,
    cactus: CactusData,
    player: PlayerData,
    mass: MassData,

    pub const MotherData = struct {};
    pub const MassData = struct {
        color: rl.Color,
        amount: u32,
    };
    pub const CactusData = struct {
        size: u8, // After 10, pops
    };
    pub const PlayerData = struct {
        username: []const u8,
        color: rl.Color,
        mass: u32,
    };
};

pub const EntityType = enum { player, mass, cactus, mother };

pub fn main() void {
    rl.initWindow(800, 600, "Hello World");
    defer rl.closeWindow();

    const playerData = EntityData.PlayerData{ .username = "Tofaa", .color = rl.Color.yellow, .mass = 1000 };
    var entity = Entity{ .position = rl.Vector2.init(200, 200), .data = EntityData{ .player = playerData } };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);
        rl.drawFPS(20, 20);
        entity.draw();

        const mouseX = rl.getMouseX();
        const mouseY = rl.getMouseY();

        const mousePos = rl.Vector2.init(@floatFromInt(mouseX), @floatFromInt(mouseY));

        var direction = mousePos.subtract(entity.position);
        const distance = rl.math.vector2Length(direction);

        if (distance > 1.0) {
            direction = rl.math.vector2Normalize(direction);
            const stepSize: f32 = 1.0;
            entity.position = entity.position.add(rl.math.vector2Scale(direction, stepSize));
        }
    }
}
