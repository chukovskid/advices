export async function payForMessage(admin:any, path: string): Promise<void> {
    const parts = path.split("/");
    if(parts.length <= 1) {
        console.log('Invalid path');
        return;
    }
    const chatId = parts[0];
    const messageId = parts[1];

    try {
        const refMessages = admin.firestore().collection(`conversation/messages/${chatId}`);
        await refMessages.doc(messageId).update({"payed": true});
        console.log("Payment successful");
        // notifyListeners(); In a server environment, you generally don't have a "listeners" concept like you would in a front-end framework.
    } catch (e) {
        console.log(e);
    }
}
