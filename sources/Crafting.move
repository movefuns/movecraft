module MoveCraft::Crafting{

    struct EmptyGrid has copy, drop, store{}

    ///
    struct Recipe2x2<phantom Grid0, phantom Grid1, phantom Grid2, phantom Grid3>{
    }

    struct Materials2x2<Grid0,Grid1,Grid2,Grid3>{
        grid0: Grid0,
        grid1: Grid1,
        grid2: Grid2,
        grid3: Grid3,
    }


}