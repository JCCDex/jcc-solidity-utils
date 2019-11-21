pragma solidity 0.4.24;

interface IENS {

    // Logged when the owner of a node assigns a new owner to a subnode.
    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);

    // Logged when the owner of a node transfers ownership to a new account.
    event Transfer(bytes32 indexed node, address owner);

    // Logged when the resolver for a node changes.
    event NewResolver(bytes32 indexed node, address resolver);

    // Logged when the TTL of a node changes
    event NewTTL(bytes32 indexed node, uint64 ttl);

    // 设置子域名属主
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
    // 设置域名解析器
    function setResolver(bytes32 node, address resolver) external;
    // 设置域名属主
    function setOwner(bytes32 node, address owner) external;
    // 设置域名TTL Time To Live
    function setTTL(bytes32 node, uint64 ttl) external;
    // 获取相应域名的属主
    function owner(bytes32 node) external view returns (address);
    // 获取相应域名的解析器
    function resolver(bytes32 node) external view returns (address);
    // 获取相应域名的TTL
    function ttl(bytes32 node) external view returns (uint64);

}
