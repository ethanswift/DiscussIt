//
//  ChatViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 2/26/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var db: Firestore!
    
    var boardName: String = ""
    
    var ref: String = ""
    
    var messageList: [Message] = []
    
    let refreshControll = UIRefreshControl()
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.9365637898, green: 0.9386104941, blue: 0.956056416, alpha: 1)
        configureMessageCollectionView()
        configureMessageInputBar()
        loadMessages()
        title = boardName // boardName

        // Do any additional setup after loading the view.
    }
    
    func loadMessages() {
            // get Messages from firestore
            let newDB = self.db.collection("works").document(self.ref)
            let chatDB = newDB.collection(self.boardName)
            chatDB.order(by: "date", descending: false).getDocuments(completion: { (querySnapshot, error) in
                if error != nil {
                    print(error!)
                } else {
                    for document in querySnapshot!.documents {
                        let dataValue = document.data()
                        let text = dataValue["text"] as! String
                        let userId = dataValue["userId"] as! String
                        let userName = dataValue["userName"] as! String
                        let messageId = dataValue["messageId"] as! String
                        let date = dataValue["date"] as! Timestamp
                        let dateFin = date.dateValue()
                        // boardName, doi and documentId
                        let user = User(senderId: userId, displayName: userName)
                        let newMessage: Message = Message(text: text, user: user, messageId: messageId, date: dateFin)
                        self.messageList.append(newMessage)
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom()
                        }
                }
            })
    }
    
    func saveMessages(text: String, boardName: String, docRefNum: String, userId: String, userName: String) {
        
        let messageID = UUID()
        let messageIDStr = messageID.uuidString
        let newDB = db.collection("works").document(docRefNum).collection(boardName)
        let newDocDB = newDB.document()
        let messageDocRef = newDocDB.documentID
        newDB.document("\(messageDocRef)").setData(["text": text,
                                                    "userId": userId,
                                                    "userName": userName,
                                                    "messageId": messageIDStr,
                                                    "date": Timestamp(date: Date()),
                                                    "boardName": boardName,
                                                    "workDocRefNumber": docRefNum,
                                                    "MessageDocumentId": messageDocRef]) { (err) in
                                                        if err != nil {
                                                            print(err!)
                                                        } else {
                                                            self.messagesCollectionView.reloadData()
                                                        }
        }
        self.messageList.removeAll()
        self.messagesCollectionView.reloadData()
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
    }
    
    func configureMessageInputBar () {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = UIColor(red: 188/255, green: 195/255, blue: 199/255, alpha: 1.0)
        messageInputBar.sendButton.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor(red: 146/255, green: 166/255, blue: 166/255, alpha: 0.3), for: .highlighted)
    }
    
    func currentSender() -> SenderType {
        let user = User(senderId: "Me", displayName: "Me")
        return user
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .cellTrailing, vertical: .cellBottom)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubbleTail(.topLeft, .pointedEdge)
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return false
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let color = #colorLiteral(red: 0.2265214622, green: 0.2928299606, blue: 0.5221264958, alpha: 1)
        return color
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return color
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = Avatar(image: #imageLiteral(resourceName: "Image"), initials: "AB")
        avatarView.set(avatar: avatar)
        avatarView.backgroundColor = UIColor.white
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let thisMessage = messageList[indexPath.section]
        let name = thisMessage.user.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: messageList[indexPath.section].sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

 extension ChatViewController: MessageCellDelegate {
        
        func didTapAvatar(in cell: MessageCollectionViewCell) {
            print("Avatar tapped")
        }
        
        func didTapMessage(in cell: MessageCollectionViewCell) {
            print("Message tapped")
        }
    
        func didTapImage(in cell: MessageCollectionViewCell) {
            print("Image tapped")
        }
        
        func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
            print("Top cell label tapped")
        }
        
        func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
            print("Bottom cell label tapped")
        }
        
        func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
            print("Top message label tapped")
        }
        
        func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
            print("Bottom label tapped")
        }
    
        func didTapAccessoryView(in cell: MessageCollectionViewCell) {
            print("Accessory view tapped")
        }    
}

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let fUser = Auth.auth().currentUser
        
        let thisUser = User(senderId: fUser?.uid ?? "Guest", displayName: fUser?.displayName ?? "Anonymous")
        
        saveMessages(text: text, boardName: self.boardName, docRefNum: self.ref, userId: thisUser.senderId, userName: thisUser.displayName)
 
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."

        self.messageInputBar.sendButton.stopAnimating()
        self.messageInputBar.inputTextView.placeholder = "Aa"
        self.messagesCollectionView.scrollToBottom(animated: true)
        loadMessages()
        self.messagesCollectionView.reloadData()

    }
    
}
