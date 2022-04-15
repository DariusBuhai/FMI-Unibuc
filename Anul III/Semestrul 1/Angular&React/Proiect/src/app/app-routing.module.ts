import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { IndexComponent } from './pages/index/index.component';
import { LoginComponent } from './pages/login/login.component';
import { RegisterComponent } from './pages/register/register.component';
import {TeacherComponent} from "./pages/teacher/teacher.component";
import {CheckLogin} from "./components/check-login.component";
import {LogoutComponent} from "./components/logout.component";
import {ProfileComponent} from "./pages/profile/profile.component";
import {ForgotPasswordComponent} from "./pages/forgot-password/forgot-password.component";

const routes: Routes = [
  {
    path:"",
    component:IndexComponent,
  },
  {
    path:"login",
    component:LoginComponent
  },
  {
    path:"logout",
    component:LogoutComponent
  },
  {
    path:"forgot-password",
    component:ForgotPasswordComponent
  },
  {
    path:"register",
    component:RegisterComponent
  },
  {
    path:"profile",
    component:ProfileComponent
  },
  {
    path:"reset",
    component:RegisterComponent
  },
  {
    path:"teacher/:id",
    component:TeacherComponent,
    canActivate: [CheckLogin],
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
