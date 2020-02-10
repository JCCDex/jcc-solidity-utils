const NodeManagemenet = artifacts.require('NodeManagemenet');

contract('NodeManagemenet', () => {
    it('get price', async () => {
        let inst = await NodeManagemenet.new();
        let nodes = await inst.getNodes();
        console.log(nodes)
        await inst.updateJingtumNodes("jingtumNodes", ["0x68747470733a2f2f73726a65303731716465773233312e6a63636465782e636e"])
        nodes = await inst.getNodes();
        console.log(nodes.jingtumNodes)
        await inst.insertJingtumNodes("jingtumNodes", ["0x68747470733a2f2f73726a65303731716465773233312e6a63636465782e636e"])
        nodes = await inst.getNodes();
        console.log(nodes.jingtumNodes)

    });
});