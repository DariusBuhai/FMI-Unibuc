import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss'],
})
export class RegisterComponent implements OnInit {
  public myForm!: FormGroup;
  constructor(
    private router: Router,
    private formBuilder: FormBuilder,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.myForm = this.formBuilder.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(5)]],
      passwordAgain: ['', [Validators.required, Validators.minLength(5)]],
    });
  }

  goToLogin() {
    this.router.navigate(['/login']);
  }

  async doRegister(): Promise<void>{
    if(this.myForm.value.password!=this.myForm.value.passwordAgain){
      window.alert("Passwords do not match!");
      return;
    }
    if (this.myForm.valid) {
      await this.authService.signUp(this.myForm.value);
    }
  }
}
