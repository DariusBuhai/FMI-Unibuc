import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { RegisterComponent } from './pages/register/register.component';
import { IndexComponent } from './pages/index/index.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import {environment} from "../environments/environment";
import {AngularFireModule} from "@angular/fire/compat";
import {AngularFireDatabaseModule} from "@angular/fire/compat/database";
import { TeacherComponent } from './pages/teacher/teacher.component';
import {CheckLogin} from "./components/check-login.component";
import { ProfileComponent } from './pages/profile/profile.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import {LogoutComponent} from "./components/logout.component";
import { ForgotPasswordComponent } from './pages/forgot-password/forgot-password.component';
import { TeachersListComponent } from './components/teachers-list/teachers-list.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterComponent,
    IndexComponent,
    TeacherComponent,
    ProfileComponent,
    NavbarComponent,
    LogoutComponent,
    ForgotPasswordComponent,
    TeachersListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AngularFireDatabaseModule
  ],
  providers: [CheckLogin],
  bootstrap: [AppComponent],
})
export class AppModule {}
