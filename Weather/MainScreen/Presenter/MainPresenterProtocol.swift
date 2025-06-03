//
//  MainPresenterProtocol.swift
//  Weather
//
//  Created by Bogdan Fartdinov on 02.06.2025.
//

import Foundation

protocol MainPresenter {
    func attachView(_ view: MainViewProtocol)
    func didPullToRefresh()
    func viewDidLoad()
}
