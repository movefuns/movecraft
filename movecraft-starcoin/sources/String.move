module MoveCraft::String{
    use StarcoinFramework::Vector;
    //use StarcoinFramework::Debug;

    const ASCII_0: u8 = 48;

    public fun to_string(num: u64):vector<u8> {
        let buf = Vector::empty<u8>();
        let i = num;
        let remainder:u8;
        loop{
            remainder = ((i % 10) as u8);
            Vector::push_back(&mut buf, ASCII_0 + remainder);
            i = i /10;
            if(i == 0){
                break
            };
        };
        Vector::reverse(&mut buf);
        buf
    }

  
    #[test]
    fun test_u64_to_string(){
        let num :u64 = 1234567890;
        let num_str_bytes:vector<u8> = b"1234567890";
        let num_to_string = to_string(num);
        //Debug::print(&num_str_bytes);
        //Debug::print(&num_to_string);  
        assert!( num_to_string == num_str_bytes, 0);
    }
}