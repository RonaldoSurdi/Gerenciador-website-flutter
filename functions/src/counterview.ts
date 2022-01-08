exports.handler = async function(req, res, firestore, cors) {
    res.set("Access-Control-Allow-Origin", "*");
    if (req.method !== "GET") {
        return res.status(405).send(`${req.method} method not allowed`);
    }
    cors(req, res, async () => {
        const stats = {
            "count": 1,
            "online": 1
        };
        const ipAddress = req.headers["x-forwarded-for"] || req.connection.remoteAddress;
        const idAddress = ipAddress.replace(/[^0-9]/g, "");
        const docRef = firestore.collection("stats").doc("data");
        return docRef.get().then(async (doc) => {
            if (!doc.exists) {
                await docRef.set({
                    "count": 1
                });
            } else {
                const item = await doc.data();
                stats.count = item.count + 1;
                await docRef.update({
                    "count": stats.count
                });
            }
            const onlineRef = docRef.collection("online");
            const timestamp = new Date(Date.now());
            const timestest = new Date(Date.now() - 60*1000);
            const userRef = onlineRef.doc(`${timestamp}${idAddress}`);
            return await userRef.get().then(async (user) => {
                const users = {
                    "id": `${timestamp}${idAddress}`,
                    "ip": ipAddress,
                    "date": timestamp.getTime()
                };
                if (!user.exists) {
                    await userRef.set(users);
                } else {
                    users.date = timestamp.getTime();
                    await userRef.update(users);
                }
                return await onlineRef.where("date", ">=", timestest.getTime()).get().then((online) => {
                    stats.online = online.size;
                    console.log(stats);
                    return res.status(200).send(stats);
                }).catch((error) => {
                    console.log(error);
                    return res.status(400).send(stats);
                });
            }).catch((error) => {
                console.log(error);
                return res.status(400).send(stats);
            });
        }).catch((error) => {
            console.log(error);
            return res.status(400).send(stats);
        });
    });
};
