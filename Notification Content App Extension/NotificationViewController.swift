
import UIKit
// #3.1 - import notification SDKs
import UserNotifications
import UserNotificationsUI
import Reachability
// #3.2 - adopt a protocol that let's us intercept
// notifications
class NotificationViewController: UIViewController, UNNotificationContentExtension{

    
    // #3.3 - these outlets allow me to animate buttons
    @IBOutlet weak var clearedTransactionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var quizModel: QuizModel! = nil
    fileprivate var rightAnswerIndexPath: IndexPath?
    private var dbContext: QuizParser?
    private var databaseManager: DatabaseManager! = nil
    private var requestManager: RequestManager! = nil
    private var user: UserModel! = nil
    private var syncManager: SyncManager! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = 650
    }
    
    override func loadView() {
        super.loadView()
        let userJson = StorageManager.getValue(key: .User)
        user  = JsonConverter.jsonToObject(stringJson: userJson!)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
            
        }
        if let path  = Bundle.main.path(forResource: "questionsDb", ofType: "db") {
            databaseManager = DatabaseManager(databasePath: path)!
            dbContext = QuizParser(databaseManager: databaseManager)
        }
        requestManager = RequestManager(url: "http://starov88-001-site9.itempurl.com/api/")
        syncManager = SyncManager(database: databaseManager, networking: requestManager, token: user.token)
        initQuizModel()
        setupNotificationView(model: quizModel!)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func initQuizModel() {
        do {
            
            quizModel = try dbContext?.getRandomQuestion()
            while(quizModel.answer.count == 0) {
                initQuizModel()
            }
        }
        catch {
        }
    }
    
    override func viewDidLayoutSubviews() {
        let height = Int(collectionView.collectionViewLayout.collectionViewContentSize.height)
        let myCGFloat = CGFloat(height)
        preferredContentSize.height = (myCGFloat+270)
    }
    
    func setupNotificationView(model: QuizModel) {
        clearedTransactionLabel.text = model.text
    }

    
    
    
    // #3.5 - called when a notification is received;
    // a good opportunity to decrypt things like
    // account or transaction numbers from the payload;
    // also good for parsing any other info, like the amount
    // to cover, out of the payload
    func didReceive(_ notification: UNNotification) {
        print("Extension received notification.")
        
//        requestManager.sendAnswers()
    }
    @IBAction func nextQuestionClick(_ sender: Any) {
        initQuizModel()
        setupNotificationView(model: quizModel!)
        self.collectionView.delegate = self
        collectionView.reloadData()
    }
} // end class NotificationViewController


extension NotificationViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "answerCell", for: indexPath)
        cell.viewWithTag(2)?.backgroundColor = .white
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = quizModel
                .answer[indexPath.row].key + ". " + quizModel
            .answer[indexPath.row].text
            if quizModel.answer[indexPath.row].text == quizModel?.correctAnswerText {
                rightAnswerIndexPath = indexPath
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = quizModel?.answer.count{
            return count
        }
        return 0
    }
}

extension NotificationViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
    }

    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8
        }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
}

extension NotificationViewController : UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .blue
        var isRightAnswer = false
        UIView.animate(withDuration: 1.0) {
            if self.quizModel.answer[indexPath.row].text == self.quizModel.correctAnswerText {
                cell?.viewWithTag(2)?.backgroundColor = .green
                isRightAnswer = true
            }
            else {
                if let rightIndexPath = self.rightAnswerIndexPath {
                    let rightAnswerCell = collectionView.cellForItem(at: rightIndexPath)
                    rightAnswerCell?.viewWithTag(2)?.backgroundColor = .green
                }
                cell?.viewWithTag(2)?.backgroundColor = UIColor(red:1.00, green:0.25, blue:0.25, alpha:1.0)
            }
        }
        self.collectionView.delegate = nil
        syncManager.sync(userId: user.id, questionId: quizModel.id, questionText: quizModel.text, isAnswer: isRightAnswer, token: user.token, addedTimeUnix: Int(Date().timeIntervalSince1970))
    }
}
