import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var imageUrl: String?
    var imageTitle: String?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
        setupGestures()
        
        if let urlString = imageUrl, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "no"))
        }
        titleLabel.text = imageTitle
    }
    
    func setupUI() {
        scrollView.delegate = self
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    //  Enable Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //  Share Image Function
    @objc func shareImage() {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    //  Setup Gestures (Double-Tap & Swipe-to-Dismiss)
    func setupGestures() {
        // Double-Tap to Zoom
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapZoom))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        // Swipe Down to Dismiss
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToDismiss))
        swipeDown.direction = .down
        scrollView.addGestureRecognizer(swipeDown)
    }
    
    //  Double-Tap to Zoom
    @objc func handleDoubleTapZoom(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: true) // Zoom out
        } else {
            let zoomPoint = sender.location(in: imageView)
            let zoomRect = CGRect(
                x: zoomPoint.x - (scrollView.frame.size.width / 4),
                y: zoomPoint.y - (scrollView.frame.size.height / 4),
                width: scrollView.frame.size.width / 2,
                height: scrollView.frame.size.height / 2
            )
            scrollView.zoom(to: zoomRect, animated: true) // Zoom in
        }
    }
    
    //  Swipe Down to Dismiss
    @objc func handleSwipeToDismiss(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
}
