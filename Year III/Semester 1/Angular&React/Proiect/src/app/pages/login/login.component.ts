import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LoginDTO } from 'src/app/interfaces/login-dto';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  isDisabled: boolean = true;
  public user: LoginDTO = {
    email: '',
    password: '',
  };
  public error: boolean | string = false;
  constructor(private authService: AuthService, private router: Router) {}

  ngOnInit(): void {}

  isNotValid(): boolean {
    return !this.user.email || !this.user.password;
  }

  async doLogin(): Promise<void> {
    this.error = false;
    if (this.validateEmail(this.user.email)) {
      await this.authService.signIn(this.user);
    } else {
      this.error = 'Email is invalid';
    }
  }

  validateEmail(email: string) {
    const re =
      /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
  }
}
