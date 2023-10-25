import { Component, OnInit } from '@angular/core';
import {AuthService} from "../../services/auth.service";
import {Router} from "@angular/router";
import {AngularFirestore} from "@angular/fire/compat/firestore";
import {User} from "../../interfaces/user";
import firebase from "firebase/compat";

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {

  public user: User = {} as User;
  private uid: string | null = null;

  public password: string = "";
  public newPassword: string = "";
  public newPasswordRepeat: string = "";

  constructor(private authService: AuthService, private router: Router, private db: AngularFirestore) {}

  async ngOnInit(): Promise<void> {
    if(!this.authService.isLoggedIn)
      await this.router.navigate(['/login'])
    this.uid = this.authService.uid;
    await this.initiateUser();
  }

  async initiateUser(): Promise<void>{
    if(this.uid!=null)
      this.user = await this.authService.getUserData(this.uid);
  }

  async saveProfile(): Promise<void>{
    if(this.uid==null)
      return;
    await this.authService.setUserData(this.user, this.uid);
    alert("Profil salvat");
  }

  async updatePassword():Promise<void>{
    if(this.newPassword!=this.newPasswordRepeat){
      alert("Parolele nu se potrivesc!")
      return
    }
    if(this.password.length<5){
      return;
    }
    await this.authService.updatePassword(this.password, this.newPassword)
  }

}
