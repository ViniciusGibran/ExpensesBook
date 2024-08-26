//
//  CategoryListView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 22/08/2024.
//

import SwiftUI
import RealmSwift

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    @EnvironmentObject var router: Router

    @State private var isShowingCategoryDetailView = false
    @State private var selectedCategory: Category? = nil

    var body: some View {
        NavigationView {
            ZStack {
                StateView(state: viewModel.viewState) {
                    List {
                        ForEach(viewModel.categories, id: \.id) { category in
                            HStack {
                                category.coloredCircle
                                Text(category.name)
                                Spacer()

                                Button(action: {
                                    selectedCategory = category
                                    isShowingCategoryDetailView = true
                                }) {}
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectCategory(category)
                                router.popToPrevious()
                            }
                        }
                        .onDelete(perform: viewModel.deleteCategory)
                    }
                    //.listStyle(InsetGroupedListStyle())
                }

                FloatingActionButton(action: {
                    selectedCategory = nil
                    isShowingCategoryDetailView = true
                }, icon: "plus", color: .blue)
            }
            .fullScreenCover(isPresented: $isShowingCategoryDetailView) {
                CategoryDetailView(viewModel: CategoryDetailViewModel(category: selectedCategory)) { updatedCategory in
                    viewModel.saveCategory(updatedCategory)
                }
            }
            .onAppear {
                viewModel.loadCategories()
            }
        }
    }
}
