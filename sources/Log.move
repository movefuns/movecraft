module MoveCraft::Log{
    use StarcoinFramework::NFT::{Self, NFT, MintCapability, BurnCapability};
    use MoveCraft::BlockBody::{Self, BlockBody};
    
    friend MoveCraft::Block;
    friend MoveCraft::Planks;

    struct Log has copy,drop,store{
    }

    const NAME: vector<u8> = b"Log";
    const DESCRIPTION: vector<u8> = b"MoveCraft Log Block";
    const IMAGE: vector<u8> = b"data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSIzMi4wMjI3MiIgaGVpZ2h0PSIzMi4wMjI3MiIgdmlld0JveD0iMCwwLDMyLjAyMjcyLDMyLjAyMjcyIj48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjIzLjk4OTI0LC0xNjMuOTg5MDkpIj48ZyBkYXRhLXBhcGVyLWRhdGE9InsmcXVvdDtpc1BhaW50aW5nTGF5ZXImcXVvdDs6dHJ1ZX0iIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0ibm9uemVybyIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjAuNSIgc3Ryb2tlLWxpbmVjYXA9ImJ1dHQiIHN0cm9rZS1saW5lam9pbj0ibWl0ZXIiIHN0cm9rZS1taXRlcmxpbWl0PSIxMCIgc3Ryb2tlLWRhc2hhcnJheT0iIiBzdHJva2UtZGFzaG9mZnNldD0iMCIgc3R5bGU9Im1peC1ibGVuZC1tb2RlOiBub3JtYWwiPjxpbWFnZSB4PSIyMjMuODMwMzIiIHk9IjE2My44NzI3NCIgdHJhbnNmb3JtPSJzY2FsZSgxLjAwMDcxLDEuMDAwNzEpIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHhsaW5rOmhyZWY9ImRhdGE6aW1hZ2UvcG5nO2Jhc2U2NCxpVkJPUncwS0dnb0FBQUFOU1VoRVVnQUFBQ0FBQUFBZ0NBWUFBQUJ6ZW5yMEFBQURuMGxFUVZSWVI4MVhWMU5UVVJqazBvMUlreUlCUW9BVUNBYVNBSUtBSU16QURKWUhGUlJuTEsvV3YyVHZkY1RlQlh4eEhDRWdoRjRWZEZTVVBrZ1Y5N3ZyVFBJSHJublpuSE9UTy92dCtjb2VwV3FyWmRWdjdaT2V1T0V2K0FVRUJBQnpUSEhBQ3c5YmdZNE1QVEFqT1FKNDYzVXYwS3l1L2YzOXNWNWR4ZXY4WWlQbGZaTnp2NEVSdWhEZytOUXNNRmQ5bjZJNWdUSlhDaWhiREpGZ3B0UHBnTzlhQjRFaEljTDhZSlVOZVAxRkY1Q1JNNUpMano5aVB5czlGdWl5SmdEcm0wUXBoM2tUME4zN0ZWaGRhQVFxbWhNb3N1dWhnTWtneklNRDVRejdSNmVCMXBRb29OTWlFVngrMGc3TVROM290ZStyQUhPQUVmc3FzTHZFSkFwb1R1QjBYUUZDN2hyNkNVYUd1RkF2QlVweURGanowOWd5aEsrMnRCaWd3eHdQcEFLYjFlcmhQaFU3dXN1QjMxMTUyZ0Vzc2llSkFwb1RPRkdiQndVNkI4ZkJpRm04dUxpSU5jK1NDa3pNenVNcm43TksydnUrWVQvREdPMmx6TVZIYlZnZjNwRU5aRi9abnBzbUNtaE80TlNCTFZCZ2FrWTZWbmlZMVAzQ3dnSXdMek1SMk56OUJiaXlzZ0lNREF5VUNCUUYyTllqOWMwY3NLaWQ5VzdqQVBaTG5VYmcyOVlSSUt0TDBaekFzWDB1S0JBVEVRWm1yRnVqWGpwamxucW03ejJmc1E0T0RnYnl6R3NyTEZqZmZOVUQ1Tm4yajBwVkRYejZEcXdzdEFKWlJad3RpdVlFVHU3UGh3S2NmcXhudTFyZnJHZG1MN1A1NmpNUElxcXJ6QVNlZitBR1Z1UkxoNk9TK2hpWkxYRlI0Y0FtOXpBd1I1MFZpdVlFanRma1FnRkd5azdsVkxQZmxMQWVqRysvNlFPeXp0azNPQk82aDMvaCtaNVNxVzlPVFo0MWZRSnpaNXNqQmI5VC9oc0NuT3MzWG5hRFdhb2FPYlBlbWlSbmVLZWgzMHNKTE5ZK0xaMmp3RVBWZGkvRnFKQk5uYXAwVXNYWnlkNEthRWFnc3RDTUhDaXdpWU5ocCtLMFcxNWV4cjV2bGZCNXo4Z0VuaHYxNGh2SzgxS0JyQXIram43aTJ2Tk9QTjlibGk0S2FFNmcxR21BQXV6VnJGTm1lMmlvK0FOMlJFYkErajl6N3dPZVc0emlDOVlzSHZEYy9SWlJUcTEzL3QvWEh5aWFFeWpPVG9RQ2RDeG42NXZCbkowd0tDaElJbEdkRGlOMjJjVFJkUFJMcjZlcnBodG1wTm1xbDV5ZkZ4OHhNRFlEcElLSzVnVFdzaFlLY0k1UFRndFQrb0tscFNXc2ZhZGxXcEk0SDNhNHViazVyT2tUUEFNL3ZKUmtIMkJPVVVsRmN3SzA1YjdUajcyY0hqRXFiQjBpNHBTYm1oR2xhc3JOUUk4NkN6aFQ2QVhaQitLajVVN1owQ3czTHU3L3V4ZG9SdURJemh6a2dDNVVic1U4YXpvWFpqZXJnV2ZPZXdSN1BXL1ZkTXZ1cmpHOGo5T1F0MmZtRkJWUnRDYndCejVSaGhWU2VyMllBQUFBQUVsRlRrU3VRbUNDIi8+PC9nPjwvZz48L3N2Zz4=";

    public fun name(): vector<u8>{
        *&NAME
    }

    public fun description(): vector<u8>{
        *&DESCRIPTION
    }

    public fun image(): vector<u8>{
        *&IMAGE
    }

    //TODO mint log should use toools.
    public(friend) fun mint(cap: &mut MintCapability<Log>): NFT<Log, BlockBody>{
        let metadata = NFT::new_meta(Self::name(), Self::description());
		let nft = NFT::mint_with_cap_v2<Log,BlockBody>(@MoveCraft, cap, metadata, Log{}, BlockBody::stackable_body(1));
		nft
    }

    public(friend) fun burn(cap: &mut BurnCapability<Log>, nft: NFT<Log, BlockBody>): u64 {
        let body = NFT::burn_with_cap(cap, nft);
        let (_, count) = BlockBody::unpack(body);
        count
    } 
}