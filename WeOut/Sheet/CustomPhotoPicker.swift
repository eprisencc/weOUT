////
////  CustomPhotoPicker.swift
////  WeOut
////
////  Created by Jacquese Whitson on 5/30/24.
////
//
//import SwiftUI
//import _PhotosUI_SwiftUI
//
//struct CustomPhotoPicker: View {
//    @EnvironmentObject var profileVm : ProfileViewModel
//    
//    @State var width: CGFloat = 100
//    @State var height: CGFloat = 100
//    @State var link: String = ""
//
//     var body: some View {
//         VStack{
//            PhotosPicker(selection: $profileVm.photoPickerItem,matching: .images) {
// if let selectedImage = profileVm.avatarImage { // if there is a image selceteds display
//                                Image(uiImage: selectedImage)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width:width,height: width)
//                                .clipShape(RoundedRectangle(cornerRadius: 20))
//                            } else {// show logo instead
//                                if link.isEmpty {
//                                    Image("Logo")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width:width,height: width)
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    
//                                } else {
//                                    DisplayPhoto(link: link,height: height, width: width)
//                                }
//                             }
//                
//            }
//            .buttonStyle(.plain)
//        }                    .onChange(of: profileVm.photoPickerItem){
//            _,_ in
//            Task {
//        if let item = profileVm.photoPickerItem,
//    let data = try? await profileVm.photoPickerItem?.loadTransferable(type: Data.self){
//                     if let image = UIImage(data: data){
//                        profileVm.avatarImage = image
//                         print("💦\(profileVm.avatarImage ?? UIImage())")
//                         print("📸Succcesffullly selected image")
////
//                         profileVm.newPhoto = Photo()
//  
//  
//                    }
//                 }
//                // update fucniton here
//  
//  profileVm.photoPickerItem = nil
//            }
//            profileVm.didSelectImage = true
//        }
//
//    }
//}
//
//#Preview {
//    CustomPhotoPicker()
//        .environmentObject(ProfileViewModel())
//}
