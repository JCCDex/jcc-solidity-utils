pragma solidity >=0.4.24;

import "../math/SafeMath.sol";
import "../utils/AddressUtils.sol";
import "../utils/Payload.sol";
import "../owner/Administrative.sol";
import "../interface/IExtendedERC20.sol";

/**
 * ERC 20 token
 * 通用的ERC20合约，创建时指定通证名称，数量，精度以及是否可铸币
 * 当minable为false, 该合约的总供给量固定不变，不可修改
 * 当minable为true, totalSupply参数为铸币的上限，函数totalSupply返回实际已发行的数量
 * https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Factory is Administrative, IExtendedERC20, Payload {
  using SafeMath for uint256;
  using AddressUtils for address;

  mapping(address => uint256) _balances;

  mapping(address => mapping(address => uint256)) _allowed;

  bool _minable;
  uint8 private _decimals;
  uint256 private _totalSupply;
  uint256 private _maxSupply;
  string private _name;
  string private _symbol;

  //constructor
  constructor(
    string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 totalSupply,
    bool minable
  ) public Administrative() {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
    _maxSupply = totalSupply * 10**uint256(decimals);
    _minable = minable;

    if (_minable) {
      _totalSupply = 0;
    } else {
      // 初始化时所有token都发送到owner
      _totalSupply = _maxSupply;
      _balances[owner()] = _totalSupply;
      emit Transfer(address(0), owner(), _totalSupply);
    }
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  /**
  不是所有的ERC20都遵循uint8，比如USDT是uint256，对于不同类型，需要做转换
   */
  function decimals() public view returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address _who) public view returns (uint256) {
    return _balances[_who];
  }

  function allowance(address _owner, address _spender)
    public
    view
    returns (uint256)
  {
    return _allowed[_owner][_spender];
  }

  function approve(address _spender, uint256 _value)
    public
    onlyPayloadSize(2 * 32)
    returns (bool)
  {
    // 检查设置数量和允许数量，防止重入修改
    require(
      (_value == 0) || (_allowed[msg.sender][_spender] == 0),
      "check value not equal zero"
    );

    /**
    不检查value和maxSupply是因为可以授权一个很大的数字，用户可以在业务中反复流转多次
     */
    _allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);

    return true;
  }

  function _transfer(
    address from,
    address to,
    uint256 value
  ) internal {
    require(!to.isZeroAddress(), "can not send to zero account");
    require(value <= _maxSupply, "More than total supply");
    require(_balances[from] >= value, "Not enough value");

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);

    emit Transfer(from, to, value);
  }

  function transfer(address _to, uint256 _value)
    public
    onlyPayloadSize(2 * 32)
    returns (bool)
  {
    _transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public onlyPayloadSize(3 * 32) returns (bool) {
    require(_allowed[_from][msg.sender] >= _value, "Not enough value");

    _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
    _transfer(_from, _to, _value);

    return true;
  }

  function increaseAllowance(address _spender, uint256 _addedValue)
    public
    onlyPayloadSize(2 * 32)
    returns (bool)
  {
    require(!_spender.isZeroAddress(), "can not send to zero account");

    _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(
      _addedValue
    );
    emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);

    return true;
  }

  function decreaseAllowance(address _spender, uint256 _subtractedValue)
    public
    onlyPayloadSize(2 * 32)
    returns (bool)
  {
    require(!_spender.isZeroAddress(), "can not send to zero account");

    _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].sub(
      _subtractedValue
    );
    emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);

    return true;
  }

  function mint(address account, uint256 value)
    public
    onlyPrivileged
    onlyPayloadSize(2 * 32)
    returns (bool)
  {
    require(!account.isZeroAddress(), "can not send to zero account");
    require(_minable, "minable must be true");
    require(_totalSupply.add(value) <= _maxSupply, "More than total supply");

    _totalSupply = _totalSupply.add(value);
    _balances[account] = _balances[account].add(value);

    emit Mint(account, value);
    emit Transfer(address(0), account, value);

    return true;
  }

  function burn(address account, uint256 value)
    public
    onlyPrivileged
    onlyPayloadSize(2 * 32)
    returns (bool)
  {
    require(!account.isZeroAddress(), "can not send to zero account");
    require(_minable, "minable must be true");
    require(_totalSupply >= value, "More than total supply");

    _totalSupply = _totalSupply.sub(value);
    _balances[account] = _balances[account].sub(value);

    emit Burn(account, value);
    emit Transfer(account, address(0), value);

    return true;
  }

  // fallback function
  function() external {
    require(false, "never receive fund.");
  }

  // only owner can kill
  function kill() public {
    if (msg.sender == owner()) selfdestruct(msg.sender);
  }
}
