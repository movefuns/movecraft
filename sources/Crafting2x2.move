module MoveCraft::Crafting2x2 {
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT::{Self, NFT};
    use StarcoinFramework::Option::{Self, Option};
    use MoveCraft::Block::{Self, Block};
    use MoveCraft::BlockBody::{BlockBody};

    struct RecipeRegistry has key {
        //TODO find other way to keep Recipe
        recipes: vector<Recipe>,
    }

    ///
    struct Recipe has store, copy, drop {
        grid0: u64,
        grid1: u64,
        grid2: u64,
        grid3: u64,
        output: u64,
    }

    struct Materials {
        grid0: Option<NFT<Block, BlockBody>>,
        grid1: Option<NFT<Block, BlockBody>>,
        grid2: Option<NFT<Block, BlockBody>>,
        grid3: Option<NFT<Block, BlockBody>>,
    }

    const CONTRACT_ACCOUNT: address = @MoveCraft;

    public fun register(grid0: u64,
                        grid1: u64,
                        grid2: u64,
                        grid3: u64,
                        output: u64, ) acquires RecipeRegistry {
        let registry = borrow_global_mut<RecipeRegistry>(CONTRACT_ACCOUNT);
        let recipe_opt = find_recipe(grid0, grid1, grid2, grid3, &registry.recipes);
        if (Option::is_some(&recipe_opt)) {
            return
        };
        let recipe = Recipe{
            grid0,
            grid1,
            grid2,
            grid3,
            output
        };
        Vector::push_back(&mut registry.recipes, recipe);
    }

    fun find_recipe(grid0: u64,
                    grid1: u64,
                    grid2: u64,
                    grid3: u64, recipes: &vector<Recipe>): Option<Recipe> {
        let len = Vector::length(recipes);
        let i = 0;
        while (i < len) {
            let r = Vector::borrow(recipes, i);
            if (grid0 == r.grid0 && grid1 == r.grid1 && grid2 == r.grid2 && grid3 == r.grid3) {
                return Option::some(*r)
            }
        };
        return Option::none()
    }

    public fun get_recipe(grid0: u64,
                          grid1: u64,
                          grid2: u64,
                          grid3: u64, ): Option<Recipe> acquires RecipeRegistry {
        let registry = borrow_global<RecipeRegistry>(CONTRACT_ACCOUNT);
        find_recipe(grid0, grid1, grid2, grid3, &registry.recipes)
    }

    /// Check the materials is match the requirement of recipe
    public fun match(recipe: &Recipe, materials: &Materials): bool {
        check_grid(recipe.grid0, &materials.grid0) &&
        check_grid(recipe.grid1, &materials.grid1) &&
        check_grid(recipe.grid2, &materials.grid2) &&
        check_grid(recipe.grid3, &materials.grid3)
    }

    fun check_grid(grid: u64, material: &Option<NFT<Block, BlockBody>>): bool {
        if (grid == 0) {
            return Option::is_none(material)
        }else {
            if (Option::is_none(material)) {
                return false
            }else {
                let m = Option::borrow(material);
                let block_meta = NFT::get_type_meta(m);
                return grid == Block::block_type(block_meta)
            }
        }
    }

    public fun new_Materials(grid0: Option<NFT<Block, BlockBody>>,
                             grid1: Option<NFT<Block, BlockBody>>,
                             grid2: Option<NFT<Block, BlockBody>>,
                             grid3: Option<NFT<Block, BlockBody>>, ): Materials {
        Materials{
            grid0,
            grid1,
            grid2,
            grid3
        }
    }

    public fun new_Materials_one(grid0: NFT<Block, BlockBody>): Materials {
        Self::new_Materials(Option::some(grid0), Option::none(), Option::none(), Option::none())
    }

    public fun destroy_empty(materials: Materials) {
        let Materials{ grid0, grid1, grid2, grid3 } = materials;
        Option::destroy_none(grid0);
        Option::destroy_none(grid1);
        Option::destroy_none(grid2);
        Option::destroy_none(grid3);
    }


    #[test]
    fun test_match() {
        let r = Recipe{
            grid0: 10,
            grid1: 0,
            grid2: 0,
            grid3: 0,
            output: 11,
        };
        let m = Self::new_Materials(Option::none(), Option::none(), Option::none(), Option::none());
        assert!(Self::match(&r, &m) == false, 100);
        Self::destroy_empty(m);
    }
}