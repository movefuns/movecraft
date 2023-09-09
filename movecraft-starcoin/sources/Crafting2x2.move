module MoveCraft::Crafting2x2 {
    use StarcoinFramework::Vector;
    use StarcoinFramework::NFT::{NFT};
    use StarcoinFramework::Option::{Self, Option};
    use StarcoinFramework::Signer;
    use MoveCraft::Block::{Self, Block, BlockBody};

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

    struct Materials has store {
        grid0: Option<NFT<Block, BlockBody>>,
        grid1: Option<NFT<Block, BlockBody>>,
        grid2: Option<NFT<Block, BlockBody>>,
        grid3: Option<NFT<Block, BlockBody>>,
    }

    const CONTRACT_ACCOUNT: address = @MoveCraft;

    public fun initialize(sender: &signer) {
        assert!(Signer::address_of(sender) == CONTRACT_ACCOUNT, 100);
        move_to(sender, RecipeRegistry {
            recipes: Vector::empty(),
        });
    }

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
                return grid == Block::block_type(m)
            }
        }
    }

    public fun new_materials(grid0: Option<NFT<Block, BlockBody>>,
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

    public fun new_materials_one(grid0: NFT<Block, BlockBody>): Materials {
        Self::new_materials(Option::some(grid0), Option::none(), Option::none(), Option::none())
    }

    public fun burn_empty_materials(materials: Materials) {
        let Materials{ grid0, grid1, grid2, grid3 } = materials;
        Option::destroy_none(grid0);
        Option::destroy_none(grid1);
        Option::destroy_none(grid2);
        Option::destroy_none(grid3);
    }

    public(friend) fun burn_materials(materials: Materials) {
        let Materials{ grid0, grid1, grid2, grid3 } = materials;
        if (Option::is_none(&grid0)) {
            Option::destroy_none(grid0);
        }else {
            let block0 = Option::destroy_some(grid0);
            Block::burn(block0);
        };
        if (Option::is_none(&grid1)) {
            Option::destroy_none(grid1);
        }else {
            let block1 = Option::destroy_some(grid1);
            Block::burn(block1);
        };
        if (Option::is_none(&grid2)) {
            Option::destroy_none(grid2);
        }else {
            let block2 = Option::destroy_some(grid2);
            Block::burn(block2);
        };
        if (Option::is_none(&grid3)) {
            Option::destroy_none(grid3);
        }else {
            let block3 = Option::destroy_some(grid3);
            Block::burn(block3);
        };
    }

    
    public fun craft(recipe: &Recipe, materials: Materials): NFT<Block, BlockBody> {
        assert!(Self::match(recipe, &materials), 100);
        Self::burn_materials(materials);
        Block::mint_by_type(recipe.output)
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
        let m = Self::new_materials(Option::none(), Option::none(), Option::none(), Option::none());
        assert!(Self::match(&r, &m) == false, 100);
        Self::burn_empty_materials(m);
    }
}