#[starknet::interface]
pub trait IBookStore<TContractState> {
    fn add_book(
        ref self: TContractState,
        title: felt252,
        author: felt252,
        description: felt252,
        price: u16,
        quantity: u8,
    );

    fn modify_books(
        ref self: TContractState,
        title: felt252,
        author: felt252,
        description: felt252,
        price: u16,
        quantity: u8,
    );

    fn remove_book(ref self: TContractState, title: felt252) -> bool;

    fn purchase_book(ref self: TContractState, title: felt252, quantity: u8) -> bool;
}

#[starknet::contract]
mod BookStore {
    use core::starknet::storage::{Map, StoragePointerWriteAccess, StoragePathEntry};

    #[storage]
    struct Storage {
        book_record: Map<felt252, bool>,
    }

    #[event]
    #[derive(Copy, Drop, starknet::Event)]
    enum Event {
        AddBook: AddBook,
        PurchaseBook: PurchaseBook,
    }

    #[derive(Copy, Drop, starknet::Event)]
    struct AddBook {
        title: felt252,
        response: felt252,
    }

    #[derive(Copy, Drop, starknet::Event)]
    struct PurchaseBook {
        book_title: felt252,
        author: felt252,
        description: felt252,
        description: u16,
        book_qty: u8,
    }


    #[abi(embed_v0)]
    impl BookStoreImpl of super::IBookStore<ContractState> {
        fn add_book(
            ref self: ContractState,
            title: felt252,
            author: felt252,
            description: felt252,
            price: u16,
            quantity: u8,
        ) {
            self.book_record.entry(title).write(true);
            self.book_record.entry(author).write(true);
            self.book_record.entry(description).write(true);
            self.book_record.entry(price).write(true);
            self.book_record.entry(quantity).write(true);

            self.emit(AddBook { title, response: 'Book has been added' })
        }

        fn modify_books(
            ref self: ContractState,
            title: felt252,
            author: felt252,
            description: felt252,
            price: u16,
            quantity: u8,
        ) {
            let book_exists = self.book_record.entry(title).read();

            if book_exists {
                self.book_title.write(title);
                self.author.write(author);
                self.description.write(description);
                self.price.write(price);
                self.book_qty.write(quantity);
                true
            } else {
                false
            }
        }


        fn remove_book(ref self: ContractState, title: felt252) -> bool {
            // let book_exists = self.book_record.entry(title).read();

            return true;
        }

        fn purchase_book(ref self: ContractState, title: felt252, quantity: u8) -> bool {
            let book_exists = self.book_record.entry(title).read();

            if book_exists {
                println!("Purchase Book");
                return true;
            } else {
                return false;
            }
        }
    }
}

///
use core::serde::Serde::ContractAddress;
#[starknet::interface]
pub trait IPurchaseBook<TContractState> {
    fn purchase(
        ref self: TContractState,
        student_name: felt252,
        book_title: felt252,
        quantity: u8,
        store_address: ContractAddress,
    ) -> bool;
}


#[starknet::contract]
mod PurchaseBook {
    use core::starknet::storage::{
        Map, StoragePointerReadAccess, StoragePointerWriteAccess, StorageMapReadAccess,
        StoragePathEntry,
    };
    use super::IBookStoreDispatcher;
    use core::ContractAddress;

    #[storage]
    struct Storage {
        purchase_book: Map<felt252, felt252>,
    }

    #[abi(embed_v0)]
    impl PurchaseBookImpl of super::IPurchaseBook<ContractState> {
        fn purchase(
            ref self: ContractState,
            student_name: felt252,
            book_title: felt252,
            quantity: u8,
            store_address: ContractAddress,
        ) -> bool {
            let bookstore_dispatcher = IBookStoreDispatcher { contract_address: store_address };

            let check = bookstore_dispatcher.purchase_book(book_title, quantity);

            if check {
                self.purchase_book.write(student_name, book_title, quantity);
                return true;
            } else {
                return false;
            }
        }
    }
}

