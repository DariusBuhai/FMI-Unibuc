import {Injectable, NgZone} from '@angular/core';
import {LoginDTO} from '../interfaces/login-dto';
import {AngularFireAuth} from '@angular/fire/compat/auth';
import {AngularFirestore, AngularFirestoreDocument} from "@angular/fire/compat/firestore";
import firebase from "firebase/compat";
import {Router} from "@angular/router";
import {User} from "../interfaces/user";

@Injectable({
  providedIn: 'root',
})
export class AuthService {

  private authUser: firebase.User | null = null;

  constructor(
      private auth: AngularFireAuth,
      public afs: AngularFirestore,
      public router: Router,
      public ngZone: NgZone
  ) {
    this.auth.authState.subscribe(user => {
      if (user) {
        this.authUser = user;
        AuthService.saveUserToLocalStorage(user);
      } else
        AuthService.deleteUserFromLocalStorage();
    })
  }

  private static saveUserToLocalStorage(user: firebase.User){
    localStorage.setItem('user', JSON.stringify(user as firebase.User));
  }

  private static deleteUserFromLocalStorage(){
    localStorage.removeItem('user');
  }

  async signUp(data: any) {
    return this.auth.createUserWithEmailAndPassword(data['email'], data['password']).then((result) => {
      if(result.user!=null) {
        this.setUserData(result.user as User, result.user.uid);
        result.user.sendEmailVerification();
        this.router.navigate(['/login']);
      }
      return true;
    }).catch((error) => {
      window.alert(error.message)
      return false;
    });
  }

  signIn(data: LoginDTO) {
    return this.auth.signInWithEmailAndPassword(data.email, data.password).then((result) => {
      if(result.user!=null)
        AuthService.saveUserToLocalStorage(result.user);
      this.ngZone.run(() => {
        this.router.navigate(['/']);
      });
    }).catch((error) => {
      window.alert(error.message)
      return false;
    });
  }

  signOut() {
    return this.auth.signOut().then(() => {
      AuthService.deleteUserFromLocalStorage();
      this.router.navigate(['/login']);
    })
  }

  async getUserData(uid: string): Promise<User>{
    const userRef: AngularFirestoreDocument<any> = this.afs.doc(`users/${uid}`);
    let user = await userRef.get().toPromise()
    return user.data() as User;
  }

  async setUserData(user: User, uid: string): Promise<void> {
    const userRef: AngularFirestoreDocument<any> = this.afs.doc(`users/${user.uid}`);
    const userData: { uid: any; emailVerified: any; displayName: any; email: any; phoneNumber: any } = {
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      emailVerified: user.emailVerified,
      phoneNumber: user.phoneNumber,
    }
    await userRef.set(userData, {
      merge: true
    })
  }

  forgotPassword(passwordResetEmail: string) {
    return this.auth.sendPasswordResetEmail(passwordResetEmail)
        .then(() => {
          window.alert('Password reset email sent, check your inbox.');
        }).catch((error) => {
          window.alert(error)
        })
  }

  async updatePassword(oldPassword: string, newPassword: string){
    if(this.authUser==null)
      return;
    try{
      await this.auth.signInWithEmailAndPassword(<string>this.authUser.email, oldPassword)
      await this.authUser.updatePassword(newPassword)
      window.alert("Parola actualizata")
    }catch (e){
      window.alert(e);
    }
  }

  get uid(): string | null{
    let userStorage = localStorage.getItem('user');
    if(userStorage == null)
      return null;
    try{
      return (JSON.parse(userStorage) as firebase.User).uid;
    }catch (e){}
    return null;
  }

  get isLoggedIn(): boolean {
    let userStorage = localStorage.getItem('user');
    if(userStorage == null)
      return false;
    try{
      const user = JSON.parse(userStorage) as firebase.User;
      return (user !== null && user.emailVerified);
    }catch (e){
      return false;
    }
  }
}
