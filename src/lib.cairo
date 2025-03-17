
#[starknet::interface]
pub trait IBookStore<TContractState> {
    fn add_book(ref self: TContractState,  title: felt252,
        author :felt252,
        description :felt252,
        price : u16,
        quantity : u8);

    fn modify_books(ref self: TContractState,  title: felt252,
        author :felt252,
        description :felt252,
        price : u16,
        quantity : u8);
}

#[starknet::contract]
mod BookStore {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
         book_record :Map<felt252,felt252> // student_name <-> book_name, :Map<felt252,felt252> // student_name <-> book_name,
    }

    #[abi(embed_v0)]
    impl BookStoreImpl of super::IBookStore<ContractState> {
        fn add_book(ref self: TContractState,  title: felt252,
            author :felt252,
            description :felt252,
            price : u16,
            quantity : u8) {
                storage.book_record.write(title);
                storage.book_record.write(author);
                storage.book_record.write(description);
                storage.book_record.write(price);
                storage.book_record.write(quantity);
            }

        fn modify_books(ref self: TContractState,  title: felt252,
            author :felt252,
            description :felt252,
            price : u16,
            quantity : u8) {

            self.book_record.title.write(title);
            self.book_record.description.write(description);
            self.book_recordauthor.write(author);
            self.book_record.price.write(price);
            self.book_record.quantity.write(quantity);

            
        }

        fn remove_book(ref self: ContractState,  book_record: Map<felt252,felt252>)->{
            
        }

    }
}
