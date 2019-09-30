pragma solidity 0.4.24;

/**
@dev Administrative 为合约提供控制权限，可以通过继承该合约的方式获得这些功能
`onlyOwner` 这样的 modifier 可以在合约中使用，通常用来表达所有权
`onlyAdministrator` 用来表达运行经营权力，和所有权分开，这样的设计可以满足项目资产拥有者和经营者进行区分的场合
无论是拥有者还是经营者，都可以是一个多签名的合约钱包，用投票方式决定权利的转移
建议使用的场景：
1. 拥有者是最后的裁决者，可以决定经营者和拥有者任免，也能决定合约自杀后的资金转移
2. 经营者可以就业务中各种情况进行决策，根据授权决定资金转移和经营者变更
 */
contract Administrative {
  address private _owner;
  address private _admin;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  event AdministratorTransferred(address indexed previousAdmin, address indexed newAdmin);

  /**
  @dev 初始化合约时，部署合约的账户自动成为owner
   */
  constructor() public {
    _owner = msg.sender;
    _admin = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
    emit AdministratorTransferred(address(0), _admin);
  }

  modifier onlyOwner() {
    require(msg.sender == _owner, "only owner can modify this");
    _;
  }

  modifier onlyAdministrator {
    require(msg.sender == _admin, "only administrator can modify this");
    _;
  }

  modifier onlyPrivileged() {
    require((msg.sender == _owner) || (msg.sender == _admin), "only owner or administrator can modify this");
    _;
  }

  /**
  @dev 放弃合约的所有权，注意，合约没有任何人可以拥有了，那么很多拥有者应该有的能力，都不能访问了
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0), "Can not transfer owner to zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }

  function transferAdministrator(address newAdmin) public onlyPrivileged {
    require(newAdmin != address(0), "Can not transfer administrator to zero address");
    emit AdministratorTransferred(_admin, newAdmin);
    _admin = newAdmin;
  }

  function owner() public view returns(address) {
    return _owner;
  }

  function admin() public view returns(address) {
    return _admin;
  }
}