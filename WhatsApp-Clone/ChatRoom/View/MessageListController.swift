//
//  MessageListController.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class MessageListController: UIViewController {
    
    // MARK: Views Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.backgroundColor = .clear
        view.backgroundColor = .clear
        setUpViews()
        messageListener()
        setUpLongPressGesture()
    }
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        subscriptions.forEach {$0.cancel()}
        subscriptions.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) hasn't been implemented")
    }
    
    // MARK: Properties
    private let viewModel: ChatRoomViewModel
    private let cellIdentifier = "messageListControllerCells"
    private var subscriptions = Set<AnyCancellable>()
    private var lastScrollPosition: String?
    
    // MARK: Custom Reaction Property
    private var startingFrame: CGRect?
    private var blurView: UIVisualEffectView?
    private var focusedView: UIView?
    private var highlightedCell: UICollectionViewCell?
    private var reactionHostVC: UIViewController?
    private var messageMenuHostVC: UIViewController?
    
    private let pullToRefresh: UIRefreshControl = {
        let pullToRefresh = UIRefreshControl()
        pullToRefresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return pullToRefresh
    }()
    
    private let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        listConfig.showsSeparators = false
        let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
        section.contentInsets.leading = 0
        section.contentInsets.trailing = 0
        // this is going to reduce inter item spacing
        section.interGroupSpacing = -10
        return section
    }

    private lazy var messagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.selfSizingInvalidation = .enabledIncludingConstraints
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.refreshControl = pullToRefresh
        
        return collectionView
    }()

    
    private let backgroundImageView: UIImageView = {
        let bgImage = UIImageView(image: .chatbackground)
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        return bgImage
    }()
    
    private let pullDownHUDView: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .black)

        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: imageConfig)
        let font = UIFont.systemFont(ofSize: 12, weight: .black)
        
        buttonConfig.image = image
        buttonConfig.baseBackgroundColor = .bubbleGreen
        buttonConfig.baseForegroundColor = .whatsAppBlack
        buttonConfig.imagePadding = 5
        buttonConfig.cornerStyle = .capsule
        buttonConfig.attributedTitle = AttributedString("Pull Down", attributes:
            AttributeContainer([NSAttributedString.Key.font: font]))
        
        let button = UIButton(configuration: buttonConfig)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        return button
    }()

    
    private func setUpViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(messagesCollectionView)
        view.addSubview(pullDownHUDView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pullDownHUDView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pullDownHUDView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func messageListener() {
        let delay = 200
        
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.messagesCollectionView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.$scrollToBottom
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink {[weak self] scrollRequest in
                if scrollRequest.scroll {
                    self?.messagesCollectionView.scrollToLastItem(at: .bottom, animated: scrollRequest.isAnimated)
                }
            }.store(in: &subscriptions)
        
        viewModel.$isPaginating
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] isPaginating in
                guard let self, let lastScrollPosition else { return }
                if isPaginating == false {
                    guard let index = viewModel.messages.firstIndex(where: { $0.id == lastScrollPosition }) else { return }
                        let indexPath = IndexPath(item: index, section: 0)
                    self.messagesCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                    self.pullToRefresh.endRefreshing()
                }
            }.store(in: &subscriptions)
    }
    
   @objc private func refreshData() {
       lastScrollPosition = viewModel.messages.first?.id
       viewModel.paginateMoreMessages()
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MessageListController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let message = viewModel.messages[indexPath.row]
        let isNewDay = viewModel.isNewDay(for: message, at: indexPath.item)
        let showSenderName = viewModel.showSenderName(for: message, at: indexPath.item)
        
        cell.backgroundColor = .clear
        cell.contentConfiguration = UIHostingConfiguration {
            BubbleView(message: message, channel: viewModel.channel, isNewDay: isNewDay, showSenderName: showSenderName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        UIApplication.dismissKeyboard()
        let messageItem = viewModel.messages[indexPath.row]
        switch messageItem.type {
         
        case .video:
            guard let videoUrlString = messageItem.videoUrl,
                  let videoUrl = URL(string: videoUrlString) else { return }
            viewModel.showMediaPlayer(videoUrl)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            pullDownHUDView.alpha = viewModel.isPaginatable ? 1 : 0
        } else {
            pullDownHUDView.alpha = 0
        }
    }
}

extension MessageListController {
    
    private func setUpLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showContextMenu))
        longPressGesture.minimumPressDuration = 0.5
        messagesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func showContextMenu(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let point = gesture.location(in: messagesCollectionView)
        guard let indexPath = messagesCollectionView.indexPathForItem(at: point) else { return }
        let message = viewModel.messages[indexPath.item]
        guard message.type.isAdminMessage == false else { return }
        
                
        guard let selectedCell = messagesCollectionView.cellForItem(at: indexPath) else { return }
        
        startingFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil)
        
        guard let snapshotView = selectedCell.snapshotView(afterScreenUpdates: false) else { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissContextMenu))
        let blurEffect = UIBlurEffect(style: .regular)

        focusedView = UIView(frame: startingFrame ?? .zero)
        blurView = UIVisualEffectView(effect: blurEffect)
        
        guard let focusedView, let blurView else { return }
        
        focusedView.isUserInteractionEnabled = false
        
        blurView.contentView.isUserInteractionEnabled = true
        blurView.contentView.addGestureRecognizer(tapGesture)
        blurView.alpha = 0
        highlightedCell = selectedCell
        highlightedCell?.alpha = 0
        
        guard let keyWindow = UIWindowScene.current?.keyWindow else { return }
        
        keyWindow.addSubview(blurView)
        keyWindow.addSubview(focusedView)
        focusedView.addSubview(snapshotView)
        blurView.frame = keyWindow.frame
        
        let isNewDay = viewModel.isNewDay(for: message, at: indexPath.item)
        let shrinkCell = shrinkCall(startingFrame?.height ?? 0)
        
        attachMenuActionItem(to: message, in: keyWindow, isNewDay)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            
            blurView.alpha = 1
            focusedView.center.y = keyWindow.center.y - 70
            snapshotView.frame = focusedView.bounds
            
            snapshotView.layer.applyShadow(color: .gray, alpha: 0.2, x: 0, y: 0, radius: 4)
            
            if shrinkCell {
                let xTranslation: CGFloat = message.direction == .received ? -80 : 80
                let translation = CGAffineTransform(translationX: xTranslation, y: 0)
                
                focusedView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).concatenating(translation)
            }

        }
    }
    
    private func attachMenuActionItem(to message: MessageItem, in window: UIWindow, _ isNewDay: Bool) {
        
        guard let focusedView, let startingFrame else { return }
        
        let shrinkCell = shrinkCall(startingFrame.height)
        
        let reactionPickerView = ReactionPickerView(message: message) {[weak self] reaction in
            self?.dismissContextMenu()
        }
        let messageMenu = MessageMenuView(message: message)
        
        let reactionHostVC = UIHostingController(rootView: reactionPickerView)
        let messageMenuHostVC = UIHostingController(rootView: messageMenu)
        
        reactionHostVC.view.backgroundColor = .clear
        reactionHostVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        messageMenuHostVC.view.backgroundColor = .clear
        messageMenuHostVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        window.addSubview(reactionHostVC.view)
        window.addSubview(messageMenuHostVC.view)
        
        var reactionPadding: CGFloat = isNewDay ? 55 : 2
        var menuPadding: CGFloat = 0
        
        if shrinkCell {
            reactionPadding += (startingFrame.height / 4)
            menuPadding -= (startingFrame.height / 3.5)
        }
        
        reactionHostVC.view.bottomAnchor.constraint(equalTo: focusedView.topAnchor, constant: reactionPadding).isActive = true
        
        reactionHostVC.view.leadingAnchor.constraint(equalTo: focusedView.leadingAnchor, constant: 20).isActive = message.direction == .received

        reactionHostVC.view.trailingAnchor.constraint(equalTo: focusedView.trailingAnchor, constant: -20).isActive = message.direction == .sent
          
        messageMenuHostVC.view.topAnchor.constraint(equalTo: focusedView.bottomAnchor, constant: menuPadding).isActive = true
        
        messageMenuHostVC.view.leadingAnchor.constraint(equalTo: focusedView.leadingAnchor, constant: 20).isActive = message.direction == .received
  
        messageMenuHostVC.view.trailingAnchor.constraint(equalTo: focusedView.trailingAnchor, constant: -20).isActive = message.direction == .sent

        self.reactionHostVC = reactionHostVC
        self.messageMenuHostVC = messageMenuHostVC
    }
     
    @objc func dismissContextMenu() {
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) { [ weak self ] in
            
            self?.focusedView?.transform = .identity
            self?.focusedView?.frame = self?.startingFrame ?? .zero
            self?.reactionHostVC?.view.removeFromSuperview()
            self?.messageMenuHostVC?.view.removeFromSuperview()
            self?.blurView?.alpha = 0
            
        } completion: { [weak self] _ in
            self?.highlightedCell?.alpha = 1
            self?.blurView?.removeFromSuperview()
            self?.focusedView?.removeFromSuperview()
            
            //Clearing References
            self?.highlightedCell = nil
            self?.focusedView = nil
            self?.blurView = nil
            self?.reactionHostVC = nil
            self?.messageMenuHostVC = nil
        }
    }
    
    private func shrinkCall(_ cellHeight: CGFloat) -> Bool {
        let screenHeight = (UIWindowScene.current?.screenHeight ?? 0) / 1.2
        let spacingForMenu = screenHeight - cellHeight
        return spacingForMenu < 190
    }
}

private extension UICollectionView {
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard numberOfItems(inSection: numberOfSections - 1) > 0 else { return }

        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfItems(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        scrollToItem(at: lastRowIndexPath, at: scrollPosition, animated: animated)
    }
}

extension CALayer {
    func applyShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, radius: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = .init(width: x, height: y)
        shadowRadius = radius
        masksToBounds = false
    }
}
#Preview {
    MessageListView(ChatRoomViewModel(.placeholder))
        .environmentObject(VoiceMessagePlayer())
}
