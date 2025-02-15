module meridian_manager::manager {
    use std::option::{Self, Option};
    use std::signer;
    use std::vector;

    use aptos_framework::account;
    use aptos_framework::object;
    use aptos_std::event::{Self, EventHandle};
    use aptos_std::smart_vector::{Self, SmartVector};

    ///
    /// Errors
    ///

    // Authorization
    const ERR_UNAUTHORIZED: u64 = 0;

    // Initialization
    const ERR_MANAGER_UNINITIALIZED: u64 = 1;
    const ERR_MANAGER_INITIALIZED: u64 = 2;

    // Business logic
    const ERR_MANAGER_INVALID_MANAGER_ADDRESS: u64 = 3;
    const ERR_MANAGER_NO_MANAGER_CHANGE_PROPOSAL: u64 = 4;
    const ERR_MANAGER_ROLE_EXISTS: u64 = 5;
    const ERR_MANAGER_ROLE_NOT_EXISTS: u64 = 6;
    const ERR_MANAGER_ROLE_ADMIN_NOT_EXISTS: u64 = 7;

    struct Manager has key {
        manager_address: address,
    }

    fun init_module(account: &signer) {
        move_to(account, Manager {
            manager_address: @0x1,
        });
    }
    ///
    /// Initialization
    ///

    /// Initialize the Thala Manager. We do not utilize an `init` module given the simplicity of this
    /// package. **MUST** be called from the original deployer account of this package.
    ///
    /// All manager operations of Thala products are gated by `manager::is_authorized(&signer)`.
    /// The authorized signer is the one controlling the supplied `manager_address`.
    ///
    /// This model allows for the deployment of 
    ///   (a) A centralized manager via an externally owned `manager_address`
    ///   (b) Governance controlled manager. In which `manager_address` is not externally owned.
    public entry fun initialize(deployer: &signer, manager_address: address) acquires Manager {
        let manager = borrow_global_mut<Manager>(@meridian_manager);
        manager.manager_address = manager_address;
    }
    
    ///
    /// Config & Param Management
    ///

    /// Change the manager address of the manager
    public entry fun change_manager_address(account: &signer, new_manager_address: address) {
        abort 0;
    }

    /// Accept the manager change, officially making the switch
    public entry fun accept_manager_proposal(account: &signer) {
        abort 0;
    }
    
    ///
    /// Role Management
    ///
    
    /// Protocol manager can create a new role
    public entry fun create_role(manager: &signer, role_name: vector<u8>, admin: Option<address>) {
        abort 0;
    }

    /// Protocol manager can set role admin address or remove admin by setting an empty Option
    public entry fun set_role_admin(manager: &signer, role_name: vector<u8>, admin: Option<address>) {
        abort 0;
    } 

    /// Role admin can renounce its admin role. This function provides a mechanism for accounts to lose their privileges
    /// if they are compromised (such as when a trusted device is misplaced)
    public entry fun renounce_role_admin(admin: &signer, role_name: vector<u8>) {
        abort 0;
    }

    /// Role admin and protocol manager can add a member to the role
    public entry fun add_role_member(admin: &signer, role_name: vector<u8>, member: address) {
        abort 0;
    }

    /// Role admin and protocol manager can remove a member from the role
    public entry fun remove_role_member(admin: &signer, role_name: vector<u8>, member: address) {
        abort 0;
    }

    ///
    /// Functions
    ///

    /// Check if an account is the current manager.
    public fun is_authorized(account: &signer): bool acquires Manager {
        assert!(initialized(), ERR_MANAGER_UNINITIALIZED);
        borrow_global<Manager>(@meridian_manager).manager_address == signer::address_of(account)
    }

    /// Query if an address it associated with the current manager
    public fun is_authorized_address(account_addr: address): bool acquires Manager {
        assert!(initialized(), ERR_MANAGER_UNINITIALIZED);
        borrow_global<Manager>(@meridian_manager).manager_address == account_addr
    }

    /// Upgrade or publish modules under the manager's resource account
    public entry fun upgrade_manager(account: &signer, metadata_serialized: vector<u8>, code: vector<vector<u8>>) {
        abort 0;
    }

    // Public Getters

    public fun initialized(): bool {
        exists<Manager>(@meridian_manager)
    }

    #[view]
    public fun manager_address(): address acquires Manager {
        borrow_global<Manager>(@meridian_manager).manager_address
    }

    //
    // Tests
    //

    #[test_only]
    public fun initialize_for_test(manager_address: address) acquires Manager {
        // In order for other modules to depend on ThalaManager and mock the manager in tests, we internally
        // create this module's deployer account to initialize from. This is important as various modules
        // may differ in the deployer address used. We do not call `create_account_for_test` as modules may
        // also share the deployer
        let deployer = account::create_signer_for_test(@meridian_manager);
        if (!account::exists_at(manager_address)) _ = account::create_account_for_test(manager_address);

        init_module(&deployer);
        initialize(&deployer, manager_address);
    }
}