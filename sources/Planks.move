module MoveCraft::Planks{
    use StarcoinFramework::NFT::{Self, Metadata};

    friend MoveCraft::Block;

    struct Planks has copy,drop,store{
    }

    const NAME: vector<u8> = b"Planks";
    const DESCRIPTION: vector<u8> = b"MoveCraft Planks Block";
    const IMAGE: vector<u8> = b"data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSIzMi4wMTUwNCIgaGVpZ2h0PSIzMi4wMTUwNCIgdmlld0JveD0iMCwwLDMyLjAxNTA0LDMyLjAxNTA0Ij48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjIzLjk1NTkzLC0xNjMuOTU2MTYpIj48ZyBkYXRhLXBhcGVyLWRhdGE9InsmcXVvdDtpc1BhaW50aW5nTGF5ZXImcXVvdDs6dHJ1ZX0iIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0ibm9uemVybyIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjAuNSIgc3Ryb2tlLWxpbmVjYXA9ImJ1dHQiIHN0cm9rZS1saW5lam9pbj0ibWl0ZXIiIHN0cm9rZS1taXRlcmxpbWl0PSIxMCIgc3Ryb2tlLWRhc2hhcnJheT0iIiBzdHJva2UtZGFzaG9mZnNldD0iMCIgc3R5bGU9Im1peC1ibGVuZC1tb2RlOiBub3JtYWwiPjxpbWFnZSB4PSIyMjMuODUwNzIiIHk9IjE2My44NzkxMyIgdHJhbnNmb3JtPSJzY2FsZSgxLjAwMDQ3LDEuMDAwNDcpIiB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHhsaW5rOmhyZWY9ImRhdGE6aW1hZ2UvcG5nO2Jhc2U2NCxpVkJPUncwS0dnb0FBQUFOU1VoRVVnQUFBQ0FBQUFBZ0NBWUFBQUJ6ZW5yMEFBQUJ1VWxFUVZSWVI4MVhxMDREUVJSbEVpQkxlUmphb0JBWUVoSVVLSEJJQkE2RlFOU2grUVUrQUluakowZ3dKRGdraW9RRWc2Z2lMWVpIczhId0dEZ2I1bXhQNzlEUW5ZNlo3ankyNTk1N3pyMTMzY1ZKODMzc2M3UTY3YTlKanNWNkk5akw4OXcvdDErZS9jejdmVi8yNi8vY3lBQUFZbGgyZVgzdmw3YldsZ0pqWUxGbFlXTm1OdkFRbnJNczgrdndlT0dCa1FGZ2NRR1dBREFzWW8rd0o3YzNWNElqMGdPVkF6allYZmNxNEZHclRWcGg3cm5mN2I3MXZjZnZkY2tCRENwRGhBcjY1OURkM0hWNnFvaTVNM0FlK0RjQXAwYzdBUWRpa1FNQXE0SUpZT1VObHh3QU9LQjBySFN1NUFvUHN1NlZORXFaa0RQaTBBRWM3bThFSExCMERJQXFUMWozUzNrZ09RREZBWTdaK2RXdFgxcGRydnRaOVFkOHp3cWg1RUJsQUZpR2lxMndHRlVPNTVUT1dRMUtOYVU4VURrQWNJQXRVL1grcitWYUdRVFBGUnhJQmdBeWhINVpwMHJYc2YyQ2RkOGxCeENiQjZ6eXEyS05hb2t1bTJ0RWRCNFlHb0N6NHoxZkM4REsyR3JHZ0dMekF6d0Z6N2prQUpnRFN1ZWMrOWtEc0l3N0pWVUxjTDdFZ2NvQmNEa0dzcW54Q2YvejhlazFJUGo4M0hTd2J2VUZyWWVmcitlRjcyOUY3aWVLUE1BeXFnckFCM0xxa1d4WXZNU3RBQUFBQUVsRlRrU3VRbUNDIiBkYXRhLXBhcGVyLWRhdGE9InsmcXVvdDtvcmlnUG9zJnF1b3Q7Om51bGx9Ii8+PC9nPjwvZz48L3N2Zz4=";

    public fun name(): vector<u8>{
        *&NAME
    }

    public fun description(): vector<u8>{
        *&DESCRIPTION
    }

    public fun image(): vector<u8>{
        *&IMAGE
    }

    public fun metadata(): Metadata{
        NFT::new_meta_with_image_data(Self::name(), Self::image(), Self::description())
    }

}