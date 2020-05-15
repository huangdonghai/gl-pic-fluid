layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

void main() {
    ivec3 grid_pos = ivec3(gl_WorkGroupID);
    uint index = get_grid_index(grid_pos);

    // cell[index].pressure = abs(get_world_coord(grid_pos, ivec3(-0.5)).x) * 10;
    // cell[index].pressure = 0;
    // if (grid_pos.y < 2)
    //     cell[index].pressure = 10;
    // return;

    if (cell[index].type == AIR) {
        cell[index].pressure = 0;
        return;
    }

    float LUp = 0;
    if (grid_pos.x > 0) {
        uint i = get_grid_index(grid_pos + ivec3(-1, 0, 0));
        LUp -= cell[i].pressure_guess * cell[index].a_x;
    }
    if (grid_pos.y > 0) {
        uint i = get_grid_index(grid_pos + ivec3(0, -1, 0));
        LUp -= cell[i].pressure_guess * cell[index].a_y;
    }
    if (grid_pos.z > 0) {
        uint i = get_grid_index(grid_pos + ivec3(0, 0, -1));
        LUp -= cell[i].pressure_guess * cell[index].a_z;
    }
    if (grid_pos.x < grid_dim.x - 1) {
        uint i = get_grid_index(grid_pos + ivec3(1, 0, 0));
        LUp += cell[i].pressure_guess * cell[index].a_x;
    }
    if (grid_pos.y < grid_dim.y - 1) {
        uint i = get_grid_index(grid_pos + ivec3(0, 1, 0));
        LUp += cell[i].pressure_guess * cell[index].a_y;
    }
    if (grid_pos.z < grid_dim.z - 1) {
        uint i = get_grid_index(grid_pos + ivec3(0, 0, 1));
        LUp += cell[i].pressure_guess * cell[index].a_z;
    }

    if (cell[index].a_diag > 0) {
        float Dinv = 1.0 / cell[index].a_diag;
        cell[index].pressure = cell[index].pressure * 0.7 + Dinv * (cell[index].rhs - LUp) * 0.3;
    } else {
        cell[index].pressure = 0;
    }
}
