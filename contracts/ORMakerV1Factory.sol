import "./ORMakerDeposit.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./interface/IORMakerV1Factory.sol";

contract ORMakerV1Factory is IORMakerV1Factory, OwnableUpgradeable {
    address private manager;
    mapping(address => address) public getMaker;

    function initialize(address _manager) public initializer {
        __Ownable_init();
        manager = _manager;
    }

    function setManager(address value) external onlyOwner {
        require(value != address(0), "Manager Incorrect");
        manager = value;
    }

    function getManager() external view returns (address) {
        return manager;
    }

    function createMaker() external returns (address store) {
        bytes32 salt = keccak256(abi.encodePacked(msg.sender));
        ORMakerDeposit makerContract = new ORMakerDeposit{salt: salt}();
        makerContract.initialize(msg.sender, address(this));
        store = address(makerContract);
        getMaker[msg.sender] = store;
        emit MakerCreated(msg.sender, store);
    }
}
