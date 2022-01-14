
const StarNotary = artifacts.require("StarNotary");


var accounts;
var owner;

contract('StarNotary', (accs)=>{
    accounts = accs;
    owner = accounts[0];
    });


    it('Can Create Star1 with Name and Symbol', async() => {
        const user1 = accounts[1];
        let instance = await StarNotary.deployed();
        let tokenId = 11;
        namestar = 'Awesome Star!';
        symbolstar = 'GBP';
        await instance.createStar1(namestar,symbolstar,tokenId, {from: user1}); 
        let result = await instance.lookUptokenIdToStarInfoResult.call(tokenId);
        let a = result.name;
        assert.equal(a,'Awesome Star!');
    });
    // create two seperate additional additional test units for two more coins to get mined. Within one unit, I was getting timed out error.
    it('Can Create Star2 with Name and Symbol', async() => {
        let tokenId2 = 12;
        const user2 = accounts[2];
        let instance = await StarNotary.deployed();
        namestar2 = 'Awesome Star2!';
        symbolstar = 'GBP';
        await instance.createStar1(namestar2,symbolstar,tokenId2, {from: user2}); 
          
    });
    it('Can Create Star3 with Name and Symbol', async() => {
        let tokenId = 13;
        const user1 = accounts[1];
        let instance = await StarNotary.deployed();
        namestar3 = 'Awesome Star3!';
        symbolstar = 'GBP';
        await instance.createStar1(namestar3,symbolstar,tokenId, {from: user1}); 
    });
    it('Two Users Can exchange Stars', async()=>{
        let instance = await StarNotary.deployed();
        const user1 = accounts[1];
        const user2 = accounts[2];
        let starId1 = 11;
        let starId2 = 12;
        let result1 = (await instance.exchangeStars.call(starId1, starId2,user2, {from: user1}));
        assert.equal(result1, user2); //checking the change of ownership of starId1 from user1 to user2
        let result2 = await instance.exchangeStars.call(starId1, starId2,user1, {from: user2});
        assert.equal(result2, user1); // checking the change of ownership of starId2 from user2 to user1
    }) 
    it('Star can be transferred from one address to another address', async()=>{
        let instance = await StarNotary.deployed();
        let user1 = accounts[1];
        let user2 = accounts[2];
        let starId1 = 13;
        let result = await instance.transferStar.call(user2, starId1, {from: user1});
        assert.equal(result, user2); 
    })