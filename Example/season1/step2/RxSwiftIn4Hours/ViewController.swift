//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

// operators: just, from, filter, take, map, flatMap

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // just는 통째
    @IBAction func exJust1() {
        // stream은 에러가 낫거나 complete 되면 종료된다.
        Observable.from(["Hello", "World"])
            .subscribe(onNext: { str in
                print(str)
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: {
                print("completed")
            }) {
                print("good")
        }.disposed(by: disposeBag)
    }
    
    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }
    
    // from 은 하나씩
    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }
    
    // map 은 메핑: 모나드 패턴
    @IBAction func exMap1() {
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }
    
    // map은 매핑
    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"]) // 이런 작업들 자체가 바로 Observable stream~
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }
    
    // 필터는 말 그대로 필터, 거르기
    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func exMap3() {
        Observable.just("800x600")
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .observeOn(MainScheduler())
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            
            .disposed(by: disposeBag)
    }
}
